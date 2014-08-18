module Abstract.Impl.Memcache.Counter.Get (
 module Abstract.Interfaces.Counter.Get,
 mkCounter'Memcache'Int'Get
) where

import Abstract.Interfaces.Counter.Get

import qualified Abstract.Impl.Memcache.Counter.Internal as MEMCACHE (mkCounter'Memcache'Int)

mkCounter'Memcache'Int'Get s t = do
 v <- MEMCACHE.mkCounter'Memcache'Int s t
 return $ counterToGet v
