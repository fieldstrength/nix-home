''

snippet lang "Language Pragma" b
{-# LANGUAGE $1 #-} $0
endsnippet

snippet reco "Record declaration" b
data $1 = $1
  {$0}
  deriving (Show, Eq)
endsnippet

''

