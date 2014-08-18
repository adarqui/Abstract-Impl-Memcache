module Abstract.Impl.Memcache.Counter.Inc (
 module Abstract.Interfaces.Counter.Inc,
 mkCounter'Memcache'Int'Inc
) where

import Abstract.Interfaces.Counter.Inc

import qualified Abstract.Impl.Memcache.Counter.Internal as MEMCACHE (mkCounter'Memcache'Int)

mkCounter'Memcache'Int'Inc s t = do
 v <- MEMCACHE.mkCounter'Memcache'Int s t
 return $ counterToInc v
