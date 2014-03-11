module Chapter15.VCard where

import Control.Monad
import Prelude hiding (lookup)

data Context = Home | Mobile | Business
               deriving (Eq, Show)

type Phone = String

albulena :: [(Context, Phone)]
albulena = [(Home, "+355-652-55512")]

nils :: [(Context, Phone)]
nils = [ (Mobile, "+47-922-55-512"), (Business, "+47-922-12-121")
       , (Home, "+47-925-55-121"), (Business, "+47-922-25-551") ]

twalumba :: [(Context, Phone)]
twalumba = [(Business, "+260-02-55-5121")]

onePersonalPhone :: [(Context, Phone)] -> Maybe Phone
onePersonalPhone ps = case lookup Home ps of
                        Nothing -> lookup Mobile ps
                        Just n  -> Just n

allBusinessPhones :: [(Context, Phone)] -> [Phone]
allBusinessPhones ps = map snd numbers
    where numbers = case filter (contextIs Business) ps of
                      [] -> filter (contextIs Mobile) ps
                      ns -> ns

contextIs :: Eq a => a -> (a, t) -> Bool
contextIs a (b, _) = a == b

oneBusinessPhone :: [(Context, Phone)] -> Maybe Phone
oneBusinessPhone ps = lookup Business ps `mplus` lookup Mobile ps

allPersonalPhones :: [(Context, Phone)] -> [Phone]
allPersonalPhones ps = map snd $ filter (contextIs Home) ps `mplus`
                                 filter (contextIs Mobile) ps

lookup :: Eq a => a -> [(a, b)] -> Maybe b
lookup _ []                      = Nothing
lookup k ((x,y):xys) | x == k    = Just y
                     | otherwise = lookup k xys

lookupM :: (MonadPlus m, Eq a) => a -> [(a, b)] -> m b
lookupM _ []                      = mzero
lookupM k ((x,y):xys) | x == k    = return y `mplus` lookupM k xys
                      | otherwise = lookupM k xys
