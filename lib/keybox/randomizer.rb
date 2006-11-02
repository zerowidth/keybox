module Keybox

    #
    # use a filesystem device to retrieve random data.  If there is a
    # some other hardware device or some service that provides random
    # byte stream, set it as the default device in this class and you
    # should be good to go.
    #
    # RandomDevice can either produce random bytes as a class or as an
    # instance.
    #
    class RandomDevice
        @@DEVICES = [ "/dev/urandom", "/dev/random" ]
        @@DEFAULT = nil

        attr_accessor :source

        def initialize(device = nil)
            if not device.nil? and File.readable?(device) then
                @source = device
            else
                @source = RandomDevice.default
            end
        end

        def random_bytes(count = 1)
            File.read(source,count)
        end
        
        class << self
            def default
                return @@DEFAULT unless @@DEFAULT.nil?

                @@DEVICES.each do |device|
                    if File.readable?(device) then
                        @@DEFAULT = device 
                        break
                    end
                end
                return @@DEFAULT
            end

            def default=(device)
                if File.readable?(device) then
                    @@DEVICES << device
                    @@DEFAULT = device
                else
                    raise "device #{device} is not readable and therefore makes a bad random device"
                end
            end

            def random_bytes(count = 1)
                File.read(RandomDevice.default,count)
            end
        end
    end


    #
    # A RandomSource uses one from a set of possible source
    # class/modules.  So long as the @@DEFAULT item responds to
    # 'random_bytes' it is fine.  
    #
    # RandomSource supplies a 'rand' method in the same vein as
    # Kernel::rand.
    #
    class RandomSource
        @@SOURCE_CLASSES = [ ::Keybox::RandomDevice, ::OpenSSL::Random ]
        @@DEFAULT = nil

        class << self
            def register(klass)
                if klass.respond_to?("random_bytes") then 
                    @@SOURCE_CLASSES << klass unless @@SOURCE_CLASSES.include?(klass)
                else
                    raise "class #{klass.name} does not have a 'random_bytes' method"
                end
            end

            def default=(klass)
                register_source_class(klass)
                @@DEFAULT = klass
            end

            def default
                return @@DEFAULT unless @@DEFAULT.nil?
            end

            def rand(max = nil)

            end
        end
    end

    # the Randomizer will randomly pick a value from anything that is an
    # array or has a to_a method.  The source of randomness is
    # determined at runtime.  Any class that can provide a method 'rand'
    # can be a random source
    class Randomizer
    end
end
