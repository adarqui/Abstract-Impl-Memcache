module Abstract.Impl.Memcache.Counter.Dec (
 module Abstract.Interfaces.Counter.Dec,
 mkCounter'Memcache'Int'Dec
) where

import Abstract.Interfaces.Counter.Dec

import qualified Abstract.Impl.Memcache.Counter.Internal as MEMCACHE (mkCounter'Memcache'Int)

mkCounter'Memcache'Int'Dec s t = do
 v <- MEMCACHE.mkCounter'Memcache'Int s t
 return $ counterToDec v
