require 'net/http'
require 'json'
require 'ox'
require 'active_support/core_ext/hash'

require 'equifax/client'
# Base
require 'equifax/worknumber/base'
# VOE
require 'equifax/worknumber/voe/instant'
require 'equifax/worknumber/voe/researched'
# VOI
require 'equifax/worknumber/voi/instant'
require 'equifax/worknumber/voi/researched'

require 'equifax/version'

module Equifax
end
