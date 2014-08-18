module Abstract.Impl.Memcache.Counter (
 module Abstract.Interfaces.Counter,
 mkCounter'Memcache'Int,
 mkCounter'Memcache'Int'Inc,
 mkCounter'Memcache'Int'Dec,
 mkCounter'Memcache'Int'Get
) where

import Abstract.Interfaces.Counter
import Abstract.Impl.Memcache.Counter.Internal (mkCounter'Memcache'Int)
import Abstract.Impl.Memcache.Counter.Inc (mkCounter'Memcache'Int'Inc)
import Abstract.Impl.Memcache.Counter.Dec (mkCounter'Memcache'Int'Dec)
import Abstract.Impl.Memcache.Counter.Get (mkCounter'Memcache'Int'Get)
