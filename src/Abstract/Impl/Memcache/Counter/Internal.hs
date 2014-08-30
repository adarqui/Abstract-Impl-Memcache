module Abstract.Impl.Memcache.Counter.Internal (
 module Abstract.Interfaces.Counter,
 CounterMemcacheWrapper,
 counterMemcacheWrapper'Int,
 defaultCounterMemcacheWrapper'Int,
 mkCounter'Memcache'Int
) where

import Control.Exception

import Abstract.Interfaces.Counter
import Network.Memcache
import Network.Memcache.Protocol
import Network.Memcache.Serializable

data CounterMemcacheWrapper t = CounterMemcacheWrapper {
 _conn :: Server,
 _key :: String,
 _n :: Int
}


mkCounter'Memcache'Int :: Int -> CounterMemcacheWrapper Int -> IO (Counter IO (CounterMemcacheWrapper Int) Int)
mkCounter'Memcache'Int n cmw  = do
 let cmw' = cmw { _n = n }
-- let cmw = defaultCounterMemcacheWrapper'Int cname n
 conn <- connect "localhost" 11211
 gentleReset'Int cmw'
 return $ defaultCounterWrapper'Int $ cmw' { _conn = conn }


incr'Int :: CounterMemcacheWrapper Int -> IO Int
incr'Int w = incrBy'Int w 1


incrBy'Int :: CounterMemcacheWrapper Int -> Int -> IO Int
incrBy'Int w by = do
 v <- Network.Memcache.incr (_conn w) (_key w) by
 return $ case v of
  Nothing -> throw OperationFailed
  (Just v') -> v'


decr'Int :: CounterMemcacheWrapper Int -> IO Int
decr'Int w = decrBy'Int w 1


decrBy'Int :: CounterMemcacheWrapper Int -> Int -> IO Int
decrBy'Int w by = do
 v <- Network.Memcache.decr (_conn w) (_key w) by
 return $ case v of
  Nothing -> throw OperationFailed
  (Just v') -> v'


get'Int :: CounterMemcacheWrapper Int -> IO (Maybe Int)
get'Int w = do
 v <- Network.Memcache.get (_conn w) (_key w)
 return v
 


reset'Int :: CounterMemcacheWrapper Int -> IO ()
reset'Int w = do
 _ <- Network.Memcache.set (_conn w) (_key w) (_n w)
 return ()


gentleReset'Int :: CounterMemcacheWrapper Int -> IO ()
gentleReset'Int w = do
 _ <- Network.Memcache.add (_conn w) (_key w) (_n w)
 return ()


defaultCounterMemcacheWrapper'Int :: String -> CounterMemcacheWrapper Int
defaultCounterMemcacheWrapper'Int cname = counterMemcacheWrapper'Int cname


counterMemcacheWrapper'Int :: String -> CounterMemcacheWrapper Int
counterMemcacheWrapper'Int cname = CounterMemcacheWrapper { _key = cname }


defaultCounterWrapper'Int :: CounterMemcacheWrapper Int -> Counter IO (CounterMemcacheWrapper Int) Int
defaultCounterWrapper'Int w =
 Counter {
  _c = w,
  _incr = incr'Int,
  _incrBy = incrBy'Int,
  _decr = decr'Int,
  _decrBy = decrBy'Int,
  _get = get'Int,
  _reset = reset'Int,
  _gentleReset = gentleReset'Int
 }
