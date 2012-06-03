module Carapace
  
  require 'openssl'
  include OpenSSL
  include PKey
  include Cipher if RUBY_VERSION < "1.8.7"

  @carapace_javascript_written = false

#  Until I can get the below to work it will need to be done in the contoller
#  helper_method :carapace_javascript


  private
  
  HEX = { 'a' => 10, 'b' => 11, 'c' => 12, 'd' => 13, 'e' => 14, 'f' => 15 } #:nodoc:

  # Pass as parameter to carapace_decrypt to ensure decryption occurs or force error
  CARAPACE_FORCE_DECRYPT = true                                              
  
  # Start a Carapace session.
  #
  # A Carapace session allows a Rails action to display and process 
  # an HTML form that returns encrypted fields. The action must start a session 
  # for both the initial display and the post-processing of the request.
  # 
  # Encryption is performed using a 1024 bit RSA key (or other key 
  # length as specified by the optional parameter)
  #
  def carapace_session(key_length=1024) #:doc:
    unless session[:carapace_private_key]
      key = RSA.new(key_length)
      session[:carapace_private_key]     = key.to_s
      session[:carapace_public_modulus]  = key.public_key.n.to_s(base=16)
      session[:carapace_public_exponent] = key.public_key.e.to_s(base=16)
    end
  end

  # Decrypt a string. The return value is the decrypted string.
  # If the string was not encrypted by the browser it is returned as-is
  # unless the force_decrypt parameter is given as CARAPACE_FORCE_DECRYPT
  # in which case nil is returned
  #
  # CARAPACE_FORCE_DECRYPT can be used to protect against accepting plaintext 
  # transmissions when the user's browser has Javascript disabled.
  #
  def carapace_decrypt(string, force_decrypt=false) #:doc:
    if carapace_enabled? then         # only decrypt if browser was enabled
      byte = 0                        # the converted byte will go here
      s = "".rjust(string.length/2)   # string to receive converted bytes
      0.upto(string.length-1) do |i|  # iterate through string one chr at a time
        ch = string[i].chr            #   current character
        nibble = HEX[ch] || ch.to_i   #   converted to its binary value
        if i%2 == 0 then              
          byte = nibble << 4          #   most significant nibble is bits 5-8
        else
          byte += nibble              #   lease significant nibble is bits 1-4
          s[i/2] = byte.chr           #   store the converted byte
        end
      end
      RSA.new(session[:carapace_private_key],nil).private_decrypt(s) # perform the decryption
    else
      force_decrypt ? nil : string    # input is unencrypted - return input 
    end                               # return error if decryption was forced 

  end
  
  # Decrypt a string. The return value is the decrypted string
  # The string is decrypted in-situ, meaning its value is modified
  # (warning, this does not call any customer accessor (e.g. "password=")
  # so any custom code (such as password hashing) will not execute.)
  #
  def carapace_decrypt!(string, force_decrypt=false) #:doc:
    decrypted_string = carapace_decrypt(string, force_decrypt)
    string.replace decrypted_string unless !decrypted_string
  end

    private
  
  # Helper method for use in the view rhtml to insert Carapace Javascript
  # The javascript is added to a page once, no matter how often this is called.
  #
  def carapace_javascript #:doc:
    unless @carapace_javascript_written
      session[:carapace_nonce] = Time.now.to_i.to_s.reverse.crypt(rand.to_s.reverse[0,2])
      @carapace_javascript_written = true
      return "<script type='text/javascript'>
        carapace_modulus = \"#{session[:carapace_public_modulus]}\" ;
        carapace_exponent = \"#{session[:carapace_public_exponent]}\" ;
        document.cookie = \"carapace_nonce=#{session[:carapace_nonce]}; path=/\";
        //alert(\"Session:#{session[:carapace_nonce]}\\nCookie:\"+document.cookie)
        rsa = new RSAKey();
        rsa.setPublic(carapace_modulus, carapace_exponent);

        function carapace_encrypt(field)
        {
          field.value = rsa.encrypt(field.value);
        }
        </script>".html_safe
    end 
  end
  
  # Returns TRUE if Carapace was enabled on the view. This does not mean that
  # data was encrypted, just that Carapace Javascript was executed by the
  # user's browser, making the Carapace encryption services available. This
  # will be TRUE if everything is set up correctly AND the user's browser has
  # Javascript enabled
  #
  # This can be used to protect against accepting plaintext 
  # transmissions when the user's browser has Javascript disabled.
  # 
  def carapace_enabled? #:doc:
        cookies["carapace_nonce"]==session[:carapace_nonce]
  end

  # This is called when Carapace is included in a controller.
  # It automatically sets upn the Carapace Javascript helper.
  def self.included(c)
	  #c.RAILS_DEFAULT_LOGGER.debug "Carapace has been included by #{c.class}"
    if (c.class == Class)
      c.helper_method :carapace_javascript
    end
  end
end
