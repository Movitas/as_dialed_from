# encoding: UTF-8

module PhoneNumber
  
  class Number
    META_DATA_FILE_PREFIX = "lib/data/PhoneNumberMetadataProto"
    
    # The minimum length of the national significant number.
    MIN_LENGTH_FOR_NSN = 3
    
    # The maximum length of the national significant number.
    MAX_LENGTH_FOR_NSN = 15
    
    # The maximum length of the country calling code.
    MAX_LENGTH_COUNTRY_CODE = 3
    
    # Region-code for the unknown region.
    UNKNOWN_REGION = "ZZ"
    
    # The country code for North American Numbering Plan Administration countries
    NANPA_COUNTRY_CODE = 1
    
    # The PLUS_SIGN signifies the international prefix.
    PLUS_SIGN = '+'
    
    # The RFC 3966 format for extensions.
    RFC3966_EXTN_PREFIX = ';ext='
    
    # These mappings map a character (key) to a specific digit that should replace it for
    # normalization purposes. Non-European digits that may be used in phone numbers are
    # mapped to a European equivalent.
    DIGIT_MAPPINGS = {
      "0" => "0",
      "1" => "1",
      "2" => "2",
      "3" => "3",
      "4" => "4",
      "5" => "5",
      "6" => "6",
      "7" => "7",
      "8" => "8",
      "9" => "9",
      # Full width
      "\uFF10" => "0",
      "\uFF11" => "1",
      "\uFF12" => "2",
      "\uFF13" => "3",
      "\uFF14" => "4",
      "\uFF15" => "5",
      "\uFF16" => "6",
      "\uFF17" => "7",
      "\uFF18" => "8",
      "\uFF19" => "9",
      # Arabic-Indic
      "\u0660" => "0",
      "\u0661" => "1",
      "\u0662" => "2",
      "\u0663" => "3",
      "\u0664" => "4",
      "\u0665" => "5",
      "\u0666" => "6",
      "\u0667" => "7",
      "\u0668" => "8",
      "\u0669" => "9",
      # Extended Arabic-Indic
      "\u06F0" => "0",
      "\u06F1" => "1",
      "\u06F2" => "2",
      "\u06F3" => "3",
      "\u06F4" => "4",
      "\u06F5" => "5",
      "\u06F6" => "6",
      "\u06F7" => "7",
      "\u06F8" => "8",
      "\u06F9" => "9"
    }
    
    # Only upper-case variants of alpha characters are stored. This map is used for
    # converting letter-based numbers to their number equivalent.
    # e.g. 1-800-GOOGLE1 = 1-800-4664531
    ALPHA_MAPPINGS = {
      'A' => '2', 'B' => '2', 'C' => '2',
      'D' => '3', 'E' => '3', 'F' => '3',
      'G' => '4', 'H' => '4', 'I' => '4',
      'J' => '5', 'K' => '5', 'L' => '5',
      'M' => '6', 'N' => '6', 'O' => '6',
      'P' => '7', 'Q' => '7', 'R' => '7', 'S' => '7',
      'T' => '8', 'U' => '8', 'V' => '8',
      'W' => '9', 'X' => '9', 'Y' => '9', 'Z' => '9'
    }.freeze
    
    # For performance reasons, amalgamate both into one map
    ALL_NORMALIZATION_MAPPINGS = DIGIT_MAPPINGS.merge ALPHA_MAPPINGS
    
    # Separate map of all symbols that we wish to retain when formatting alpha
    # numbers. This includes digits, ASCII letters and number grouping symbols such
    # as '-' and ' '.
    ALL_PLUS_NUMBER_GROUPING_SYMBOLS = {
      '0' => '0',
      '1' => '1',
      '2' => '2',
      '3' => '3',
      '4' => '4',
      '5' => '5',
      '6' => '6',
      '7' => '7',
      '8' => '8',
      '9' => '9',
      'A' => 'A',
      'B' => 'B',
      'C' => 'C',
      'D' => 'D',
      'E' => 'E',
      'F' => 'F',
      'G' => 'G',
      'H' => 'H',
      'I' => 'I',
      'J' => 'J',
      'K' => 'K',
      'L' => 'L',
      'M' => 'M',
      'N' => 'N',
      'O' => 'O',
      'P' => 'P',
      'Q' => 'Q',
      'R' => 'R',
      'S' => 'S',
      'T' => 'T',
      'U' => 'U',
      'V' => 'V',
      'W' => 'W',
      'X' => 'X',
      'Y' => 'Y',
      'Z' => 'Z',
      'a' => 'A',
      'b' => 'B',
      'c' => 'C',
      'd' => 'D',
      'e' => 'E',
      'f' => 'F',
      'g' => 'G',
      'h' => 'H',
      'i' => 'I',
      'j' => 'J',
      'k' => 'K',
      'l' => 'L',
      'm' => 'M',
      'n' => 'N',
      'o' => 'O',
      'p' => 'P',
      'q' => 'Q',
      'r' => 'R',
      's' => 'S',
      't' => 'T',
      'u' => 'U',
      'v' => 'V',
      'w' => 'W',
      'x' => 'X',
      'y' => 'Y',
      'z' => 'Z',
      '-' => '-',
      '\uFF0D' => '-',
      '\u2010' => '-',
      '\u2011' => '-',
      '\u2012' => '-',
      '\u2013' => '-',
      '\u2014' => '-',
      '\u2015' => '-',
      '\u2212' => '-',
      '/'      => '/',
      '\uFF0F' => '/',
      ' '      => ' ',
      '\u3000' => ' ',
      '\u2060' => ' ',
      '.'      => '.',
      '\uFF0E' => '.'
    }.freeze
    
    # Pattern that makes it easy to distinguish whether a region has a unique
    # international dialing prefix or not. If a region has a unique international
    # prefix (e.g. 011 in USA), it will be represented as a string that contains a
    # sequence of ASCII digits. If there are multiple available international
    # prefixes in a region, they will be represented as a regex string that always
    # contains character(s) other than ASCII digits. Note this regex also includes
    # tilde, which signals waiting for the tone.
    UNIQUE_INTERNATIONAL_PREFIX = /[\d]+(?:[~\u2053\u223C\uFF5E][\d]+)?/
    # UNIQUE_INTERNATIONAL_PREFIX = Regexp.compile("[\\d]+(?:[~\u2053\u223C\uFF5E][\\d]+)?")
    
    # Regular expression of acceptable punctuation found in phone numbers. This
    # excludes punctuation found as a leading character only. This consists of dash
    # characters, white space characters, full stops, slashes, square brackets,
    # parentheses and tildes. It also includes the letter 'x' as that is found as a
    # placeholder for carrier information in some phone numbers.
    VALID_PUNCTUATION = "-x\u2010-\u2015\u2212\u30FC\uFF0D-\uFF0F \u00A0\u200B\u2060\u3000()" + "\uFF08\uFF09\uFF3B\uFF3D.\\[\\]/~\u2053\u223C\uFF5E"
    # VALID_PUNCTUATION = "-x\u2010-\u2015\u2212\uFF0D-\uFF0F " + "\u00A0\u200B\u2060\u3000()\uFF08\uFF09\uFF3B\uFF3D.\\[\\]/~\u2053\u223C\uFF5E"
    
    # Digits accepted in phone numbers (ascii, fullwidth, arabic-indic, and eastern
    # arabic digits).
    VALID_DIGITS = "0-9\uFF10-\uFF19\u0660-\u0669\u06F0-\u06F9"
    
    # We accept alpha characters in phone numbers, ASCII only, upper and lower
    # case.
    VALID_ALPHA = "A-Za-z"
    
    # Valid plus characters
    PLUS_CHARS = "+\uFF0B"
    
    #
    LEADING_PLUS_CHARS_PATTERN = Regexp.compile "^[" + PLUS_CHARS + "]+"
    
    SEPARATOR_PATTERN = Regexp.compile("[" + VALID_PUNCTUATION + "]+", "g")
    
    # Capturing digit pattern
    CAPTURING_DIGIT_PATTERN = Regexp.compile('([' + VALID_DIGITS + '])')
    
    # Regular expression of acceptable characters that may start a phone number for
    # the purposes of parsing. This allows us to strip away meaningless prefixes to
    # phone numbers that may be mistakenly given to us. This consists of digits,
    # the plus symbol and arabic-indic digits. This does not contain alpha
    # characters, although they may be used later in the number. It also does not
    # include other punctuation, as this will be stripped later during parsing and
    # is of no information value when parsing a number.
    VALID_START_CHAR_PATTERN = Regexp.compile('[' + PLUS_CHARS + VALID_DIGITS + ']')
    
    # Regular expression of characters typically used to start a second phone
    # number for the purposes of parsing. This allows us to strip off parts of the
    # number that are actually the start of another number, such as for:
    # (530) 583-6985 x302/x2303 -> the second extension here makes this actually
    # two phone numbers, (530) 583-6985 x302 and (530) 583-6985 x2303. We remove
    # the second extension so that the first number is parsed correctly.
    SECOND_NUMBER_START_PATTERN = /[\\\/] *x/
    
    # Regular expression of trailing characters that we want to remove. We remove
    # all characters that are not alpha or numerical characters. The hash character
    # is retained here, as it may signify the previous block was an extension.
    UNWANTED_END_CHAR_PATTERN = Regexp.compile('[^' + VALID_DIGITS + VALID_ALPHA + '#]+$')
    
    # We use this pattern to check if the phone number has at least three letters
    # in it - if so, then we treat it as a number where some phone-number digits
    # are represented by letters.
    VALID_ALPHA_PHONE_PATTERN = /(?:.*?[A-Za-z]){3}.*/
    # VALID_ALPHA_PHONE_PATTERN = Regexp.compile("(?:.*?[A-Za-z]){3}.*")
    
    # Regular expression of viable phone numbers. This is location independent.
    # Checks we have at least three leading digits, and only valid punctuation,
    # alpha characters and digits in the phone number. Does not include extension
    # data. The symbol 'x' is allowed here as valid punctuation since it is often
    # used as a placeholder for carrier codes, for example in Brazilian phone
    # numbers. We also allow multiple '+' characters at the start.
    # Corresponds to the following:
    # plus_sign*([punctuation]*[digits]){3,}([punctuation]|[digits]|[alpha])*
    # Note VALID_PUNCTUATION starts with a -, so must be the first in the range.
    VALID_PHONE_NUMBER = '[' + PLUS_CHARS + ']*(?:[' + VALID_PUNCTUATION + ']*[' + VALID_DIGITS + ']){3,}[' + VALID_PUNCTUATION + VALID_ALPHA + VALID_DIGITS + ']*'
    
    # Default extension prefix to use when formatting. This will be put in front of
    # any extension component of the number, after the main national number is
    # formatted. For example, if you wish the default extension formatting to be
    # ' extn: 3456', then you should specify ' extn: ' here as the default
    # extension prefix. This can be overridden by region-specific preferences.
    DEFAULT_EXTN_PREFIX = " ext. "
    
    #
    CAPTURING_EXTN_DIGITS = '([' + VALID_DIGITS + ']{1,7})'
    
    # Regexp of all possible ways to write extensions, for use when parsing. This
    # will be run as a case-insensitive regexp match. Wide character versions are
    # also provided after each ASCII version. There are three regular expressions
    # here. The first covers RFC 3966 format, where the extension is added using
    # ';ext='. The second more generic one starts with optional white space and
    # ends with an optional full stop (.), followed by zero or more spaces/tabs and
    # then the numbers themselves. The other one covers the special case of
    # American numbers where the extension is written with a hash at the end, such
    # as '- 503#'. Note that the only capturing groups should be around the digits
    # that you want to capture as part of the extension, or else parsing will fail!
    # We allow two options for representing the accented o - the character itself,
    # and one in the unicode decomposed form with the combining acute accent.
    KNOWN_EXTN_PATTERNS = RFC3966_EXTN_PREFIX + CAPTURING_EXTN_DIGITS + '|' + '[ \u00A0\\t,]*' + '(?:ext(?:ensi(?:o\u0301?|\u00F3))?n?|\uFF45\uFF58\uFF54\uFF4E?|' + '[,x\uFF58#\uFF03~\uFF5E]|int|anexo|\uFF49\uFF4E\uFF54)' + '[:\\.\uFF0E]?[ \u00A0\\t,-]*' + CAPTURING_EXTN_DIGITS + '#?|' + '[- ]+([' + VALID_DIGITS + ']{1,5})#'
    # KNOWN_EXTN_PATTERNS = "[ \u00A0\\t,]*(?:ext(?:ensio)?n?|" + "\uFF45\uFF58\uFF54\uFF4E?|[,x\uFF58#\uFF03~\uFF5E]|int|anexo|\uFF49\uFF4E\uFF54)" + "[:\\.\uFF0E]?[ \u00A0\\t,-]*([" + VALID_DIGITS + "]{1,7})#?|[- ]+([" + VALID_DIGITS + "]{1,5})#"
    
    # Regexp of all known extension prefixes used by different regions followed by
    # 1 or more valid digits, for use when parsing.
    EXTN_PATTERN = Regexp.compile('(?:' + KNOWN_EXTN_PATTERNS + ')$', 'i')
    
    # We append optionally the extension pattern to the end here, as a valid phone
    # number may have an extension prefix appended, followed by 1 or more digits.
    VALID_PHONE_NUMBER_PATTERN = Regexp.compile('^' + VALID_PHONE_NUMBER + '(?:' + KNOWN_EXTN_PATTERNS + ')?' + '$', 'i')
    
    NON_DIGITS_PATTERN = /\D+/
    # NON_DIGITS_PATTERN = Regexp.compile("(\\D+)")
    
    # This was originally set to $1 but there are some countries for which the
    # first group is not used in the national pattern (e.g. Argentina) so the $1
    # group does not match correctly.  Therefore, we use \d, so that the first
    # group actually used in the pattern will be matched.
    FIRST_GROUP_PATTERN = /(\$\d)/
    # FIRST_GROUP_PATTERN = Regexp.compile("(\\$1)")
    
    # A list of all country codes where national significant numbers (excluding any national prefix)
    # exist that start with a leading zero.
    LEADING_ZERO_COUNTRIES = [
      39,   # Italy
      47,   # Norway
      225,  # Cote d'Ivoire
      227,  # Niger
      228,  # Togo
      241,  # Gabon
      37    # Vatican City
    ].freeze
    
    NP_PATTERN = Regexp.compile("\\$NP")
    FG_PATTERN = Regexp.compile("\\$FG")
    CC_PATTERN = Regexp.compile("\\$CC")
    
    # INTERNATIONAL and NATIONAL formats are consistent with the definition in
    # ITU-T Recommendation E. 123. For example, the number of the Google Zurich
    # office will be written as '+41 44 668 1800' in INTERNATIONAL format, and as
    # '044 668 1800' in NATIONAL format. E164 format is as per INTERNATIONAL format
    # but with no formatting applied, e.g. +41446681800. RFC3966 is as per
    # INTERNATIONAL format, but with all spaces and other separating symbols
    # replaced with a hyphen, and with any phone number extension appended with
    # ';ext='.
    PHONE_NUMBER_FORMAT = {
      :E164          => 0,
      :INTERNATIONAL => 1,
      :NATIONAL      => 2,
      :RFC3966       => 3
    }.freeze
    
    # Type of phone numbers.
    PHONE_NUMBER_TYPE = {
      :FIXED_LINE => 0,
      :MOBILE => 1,
      # In some regions (e.g. the USA), it is impossible to distinguish between
      # fixed-line and mobile numbers by looking at the phone number itself.
      :FIXED_LINE_OR_MOBILE => 2,
      # Freephone lines
      :TOLL_FREE => 3,
      :PREMIUM_RATE => 4,
      # The cost of this call is shared between the caller and the recipient, and
      # is hence typically less than PREMIUM_RATE calls. See
      # http://en.wikipedia.org/wiki/Shared_Cost_Service for more information.
      :SHARED_COST => 5,
      # Voice over IP numbers. This includes TSoIP (Telephony Service over IP).
      :VOIP => 6,
      # A personal number is associated with a particular person, and may be routed
      # to either a MOBILE or FIXED_LINE number. Some more information can be found
      # here: http://en.wikipedia.org/wiki/Personal_Numbers
      :PERSONAL_NUMBER => 7,
      :PAGER => 8,
      # Used for 'Universal Access Numbers' or 'Company Numbers'. They may be
      # further routed to specific offices, but allow one number to be used for a
      # company.
      :UAN => 9,
      # A phone number is of type UNKNOWN when it does not fit any of the known
      # patterns for a specific region.
      :UNKNOWN => 10
    }.freeze
    
    # Types of phone number matches. See detailed description beside the
    # isNumberMatch() method.
    MATCH_TYPE = {
      :NOT_A_NUMBER    => 0,
      :NO_MATCH        => 1,
      :SHORT_NSN_MATCH => 2,
      :NSN_MATCH       => 3,
      :EXACT_MATCH     => 4
    }.freeze
    
    # Possible outcomes when testing if a PhoneNumber is possible.
    VALIDATION_RESULT = {
      :IS_POSSIBLE          => 0,
      :INVALID_COUNTRY_CODE => 1,
      :TOO_SHORT            => 2,
      :TOO_LONG             => 3
    }.freeze
    
    attr_accessor :number
    
    alias_method :to_s, :number
    
    def initialize(number)
      @number = number
    end
    
    # Attempts to extract a possible number from the string passed in. This
    # currently strips all leading characters that cannot be used to start a phone
    # number. Characters that can be used to start a phone number are defined in
    # the VALID_START_CHAR_PATTERN. If none of these characters are found in the
    # number passed in, an empty string is returned. This function also attempts to
    # strip off any alternative extensions or endings if two or more are present,
    # such as in the case of: (530) 583-6985 x302/x2303. The second extension here
    # makes this actually two phone numbers, (530) 583-6985 x302 and (530) 583-6985
    # x2303. We remove the second extension so that the first number is parsed
    # correctly
    def extract_possible_number
      start = @number.index VALID_START_CHAR_PATTERN
      
      if start
        possible_number = @number[start..-1]
        # Remove trailing non-alpha non-numerical characters.
        
        possible_number = possible_number.sub UNWANTED_END_CHAR_PATTERN, ""
        
        # Check for extra numbers at the end.
        second_number_start = possible_number.index SECOND_NUMBER_START_PATTERN
        if second_number_start
          possible_number = possible_number[0..second_number_start]
        end
      else
        possible_number = "";
      end
      
      possible_number
      
    end
    
    # Checks to see if the string of characters could possibly be a phone number at all. At the
    # moment, checks to see that the string begins with at least 3 digits, ignoring any punctuation
    # commonly found in phone numbers.
    # This method does not require the number to be normalized in advance - but does assume that
    # leading non-number symbols have been removed, such as by the method extractpossible_number.
    def is_viable?
      return false unless (MIN_LENGTH_FOR_NSN..MAX_LENGTH_FOR_NSN).include? @number.length
      VALID_PHONE_NUMBER_PATTERN.match(@number) ? true : false
    end
    
    # Normalizes a string of characters representing a phone number. This performs
    # the following conversions:
    #  - Wide-ascii digits are converted to normal ASCII (European) digits.
    #  - Letters are converted to their numeric representation on a telephone
    # keypad. The keypad used here is the one defined in ITU Recommendation E.161.
    # This is only done if there are 3 or more letters in the number, to lessen the
    # risk that such letters are typos - otherwise alpha characters are stripped.
    #  - Punctuation is stripped.
    #  - Arabic-Indic numerals are converted to European numerals.
    def normalize
      if matches_entirely(VALID_ALPHA_PHONE_PATTERN, @number)
        normalize_helper(@number, ALL_NORMALIZATION_MAPPINGS)
      else
        normalize_helper(@number, DIGIT_MAPPINGS)
      end
    end
    
    def normalize_digits_only
      normalize_helper(@number, DIGIT_MAPPINGS)
    end
    
    # Normalizes a string of characters representing a phone number by replacing
    # all characters found in the accompanying map with the values therein, and
    # stripping all other characters if removeNonMatches is true.
    def normalize_helper(number, normalization_replacements, remove_non_matches=true)
      normalized_number = ""
      
      number.each_char do |character|
        new_digit = normalization_replacements[character.upcase]
        
        if new_digit
          normalized_number << new_digit
        else
          normalized_number << character unless remove_non_matches
        end
        # If neither of the above are true, we remove this character.
      end
      
      normalized_number
    end
    
    # Check whether the entire input sequence can be matched against the regular
    # expression.
    def matches_entirely(regex, str)
      matched_groups = (regex.class == String) ? str.match('^(?:' + regex + ')$') : str.match(regex);
      matched_length = matched_groups && matched_groups[0].length == str.length
      (matched_groups && matched_length) ? true : false
    end
    
  end
  
end