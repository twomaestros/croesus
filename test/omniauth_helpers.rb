module Croesus
  module Test
    module OmniauthHelpers
      def omniauth_facebook_test_hash
        {
          uid: '123',
          provider: 'facebook',
          info: {
            nickname: 'eakinci1',
            email: 'ersin@twomaestros.com',
            name: 'Ersin Akinci',
            first_name: 'Ersin',
            last_name: 'Akinci',
            image: 'http://www.example.com/example.jpg',
            urls: { Facebook: 'http://facebook.com/eakinci1' },
            location: 'San Francisco, California',
            verified: false
          },
          user_info: { nickname: 'eakinci1'},
          credentials: {
            token: 'abcdef',
            expires_at: '1469851726'
          },
          extra: {
            user_hash: {
              id: '123',
              link: "http://facebook.com/eakinci1",
              email: "ersin@twomaestros.com",
              first_name: "Ersin",
              last_name: "Akinci",
              website: "http://www.twomaestros.com"
            }
          }
        }
      end
    end
  end
end