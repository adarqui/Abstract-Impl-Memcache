module Abstract.Impl.Memcache.Counter.Internal (
 module Abstract.Interfaces.Counter,
 CounterMemcache,
 counterMemcache'Int,
 defaultCounterMemcache'Int,
 mkCounter'Memcache'Int
) where

import Control.Exception

import Abstract.Interfaces.Counter
import Network.Memcache
import Network.Memcache.Protocol
import Network.Memcache.Serializable

data CounterMemcache t = CounterMemcache {
 _conn :: Server,
 _key :: String,
 _n :: Int
}


mkCounter'Memcache'Int :: Int -> CounterMemcache Int -> IO (Counter IO Int)
mkCounter'Memcache'Int n cmw  = do
 let cmw' = cmw { _n = n }
-- let cmw = defaultCounterMemcache'Int cname n
 conn <- connect "localhost" 11211
 gentleReset'Int cmw'
 return $ defaultCounter'Memcache'Int $ cmw' { _conn = conn }


incr'Int :: CounterMemcache Int -> IO Int
incr'Int w = incrBy'Int w 1


incrBy'Int :: CounterMemcache Int -> Int -> IO Int
incrBy'Int w by = do
 v <- Network.Memcache.incr (_conn w) (_key w) by
 return $ case v of
  Nothing -> throw OperationFailed
  (Just v') -> v'


decr'Int :: CounterMemcache Int -> IO Int
decr'Int w = decrBy'Int w 1


decrBy'Int :: CounterMemcache Int -> Int -> IO Int
decrBy'Int w by = do
 v <- Network.Memcache.decr (_conn w) (_key w) by
 return $ case v of
  Nothing -> throw OperationFailed
  (Just v') -> v'


get'Int :: CounterMemcache Int -> IO (Maybe Int)
get'Int w = do
 v <- Network.Memcache.get (_conn w) (_key w)
 return v
 


reset'Int :: CounterMemcache Int -> IO ()
reset'Int w = do
 _ <- Network.Memcache.set (_conn w) (_key w) (_n w)
 return ()


gentleReset'Int :: CounterMemcache Int -> IO ()
gentleReset'Int w = do
 _ <- Network.Memcache.add (_conn w) (_key w) (_n w)
 return ()


defaultCounterMemcache'Int :: String -> CounterMemcache Int
defaultCounterMemcache'Int cname = counterMemcache'Int cname


counterMemcache'Int :: String -> CounterMemcache Int
counterMemcache'Int cname = CounterMemcache { _key = cname }


defaultCounter'Memcache'Int :: CounterMemcache Int -> Counter IO Int
defaultCounter'Memcache'Int w =
 Counter {
  _incr = incr'Int w,
  _incrBy = incrBy'Int w,
  _decr = decr'Int w,
  _decrBy = decrBy'Int w,
  _get = get'Int w,
  _reset = reset'Int w,
  _gentleReset = gentleReset'Int w
 }
