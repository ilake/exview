# -*- encoding : utf-8 -*-
# CountrySelect
module ActionView
  module Helpers
    module FormOptionsHelper
      # Return select and option tags for the given object and method, using country_options_for_select to generate the list of option tags.
      def country_select(object, method, priority_countries = nil, options = {}, html_options = {})
        InstanceTag.new(object, method, self, options.delete(:object)).to_country_select_tag(priority_countries, options, html_options)
      end
      # Returns a string of option tags for pretty much any country in the world. Supply a country name as +selected+ to
      # have it marked as the selected option tag. You can also supply an array of countries as +priority_countries+, so
      # that they will be listed above the rest of the (long) list.
      #
      # NOTE: Only the option tags are returned, you have to wrap this call in a regular HTML select tag.
      def country_options_for_select(selected = nil, priority_countries = nil)
        country_options = ""

        if priority_countries
          country_options += options_for_select(priority_countries, selected)
          country_options += "<option value=\"\" disabled=\"disabled\">-------------</option>\n"
          # prevents selected from being included twice in the HTML which causes
          # some browsers to select the second selected option (not priority)
          # which makes it harder to select an alternative priority country
          selected=nil if priority_countries.include?(selected)
        end

        return country_options + options_for_select(COUNTRIES_HASH.map{|k,v| [v, k] }, selected)
      end

      COUNTRIES_HASH = {
        "AF" => "Afghanistan",
        "AL" => "Albania",
        "AG" => "Algeria",
        "AN" => "Andorra",
        "AO" => "Angola",
        "AV" => "Anguilla",
        "AY" => "Antarctica",
        "AC" => "Antigua and Barbuda",
        "AR" => "Argentina",
        "AM" => "Armenia",
        "AA" => "Aruba",
        "AT" => "Ashmore and Cartier Islands",
        "AS" => "Australia",
        "AU" => "Austria",
        "AJ" => "Azerbaijan",
        "PO" => "Azores",
        "BF" => "Bahamas The",
        "BA" => "Bahrain",
        "FQ" => "Baker Island",
        "BG" => "Bangladesh",
        "BB" => "Barbados",
        "BS" => "Bassas da India",
        "BO" => "Belarus",
        "BE" => "Belgium",
        "BH" => "Belize",
        "BN" => "Benin",
        "BD" => "Bermuda",
        "BT" => "Bhutan",
        "UV" => "Birkina Faso",
        "BL" => "Bolivia",
        "BK" => "Bosnia-Herzegovina",
        "BC" => "Botswana",
        "BV" => "Bouvet Island",
        "BR" => "Brazil",
        "IO" => "British Indian Ocean Territory",
        "BX" => "Brunei",
        "BU" => "Bulgaria",
        "BM" => "Burma",
        "BY" => "Burundi",
        "CB" => "Cambodia",
        "CM" => "Cameroon",
        "CA" => "Canada",
        "SP" => "Canary Islands",
        "CV" => "Cape Verde",
        "CJ" => "Cayman Islands",
        "CT" => "Central African Republic",
        "CD" => "Chad",
        "CI" => "Chile",
        "CH" => "China Peoples Republic of",
        "KR" => "Christman Island (Pacific Ocean)",
        "KT" => "Christmas Island (Indian Ocean)",
        "IP" => "Clipperton Island",
        "CK" => "Cocos (Keeling) Islands",
        "CO" => "Colombia",
        "CN" => "Comoros",
        "CF" => "Congo",
        "CW" => "Cook Islands",
        "CR" => "Coral Sea Islands Territory",
        "VP" => "Corsica",
        "CS" => "Costa Rica",
        "IV" => "Cote d lvoire (Ivory Coast)",
        "HR" => "Croatia",
        "CU" => "Cuba",
        "CY" => "Cyprus",
        "EZ" => "Czech Republic",
        "DA" => "Denmark",
        "DJ" => "Djibouti",
        "DO" => "Dominica",
        "DR" => "Dominican Republic",
        "EC" => "Ecuador",
        "EG" => "Egypt",
        "ES" => "El Salvador",
        "EK" => "Equatorial Guinea",
        "ER" => "Eritrea",
        "EN" => "Estonia",
        "ET" => "Ethiopia",
        "EU" => "Europa Island",
        "FK" => "Falkland Islands (Isles Malvinas)",
        "FO" => "Faroe Islands",
        "FJ" => "Fiji",
        "FI" => "Finland",
        "FR" => "France",
        "FG" => "French Guiana",
        "FP" => "French Polynesia",
        "FS" => "French Southern and Antarctic Lands",
        "GB" => "Gabon",
        "GA" => "Gambia The",
        "GZ" => "Gaza Strip",
        "GG" => "Georgia",
        "GM" => "Germany",
        "GH" => "Ghana",
        "GI" => "Gibraltar",
        "GO" => "Glorioso Islands",
        "GR" => "Greece",
        "GL" => "Greenland",
        "GJ" => "Grenada",
        "GP" => "Guadeloupe",
        "GT" => "Guatemala",
        "GK" => "Guernsey",
        "GV" => "Guinea",
        "PU" => "Guinea-Bissau",
        "GY" => "Guyana",
        "HA" => "Haiti",
        "HM" => "Heard Island and McDonald Island",
        "HO" => "Honduras",
        "HK" => "Hong Kong",
        "HQ" => "Howland Island",
        "HU" => "Hungary",
        "IC" => "Iceland",
        "IN" => "India",
        "ID" => "Indonesia",
        "IR" => "Iran",
        "IZ" => "Iraq",
        "IY" => "Iraq-Saudi Arabia Neutral Zone",
        "EI" => "Ireland",
        "IM" => "Isle of Man",
        "IS" => "Israel",
        "IT" => "Italy",
        "JM" => "Jamaica",
        "JN" => "Jan Mayan",
        "JA" => "Japan",
        "DQ" => "Jarvis Island",
        "JE" => "Jersey",
        "JQ" => "Johnston Atoll",
        "JO" => "Jordan",
        "JU" => "Juan de Nova Island",
        "KZ" => "Kazakhstan",
        "KE" => "Kenya",
        "KQ" => "Kingman Reef",
        "KP" => "Kiribati",
        "KN" => "Korea Democratic Peoples Republic of (North)",
        "KS" => "Korea Republic of (South)",
        "KU" => "Kuwait",
        "KG" => "Kyrgyzstan",
        "LA" => "Laos",
        "LG" => "Latvia",
        "LE" => "Lebanon",
        "LS" => "Leichtenstein",
        "LT" => "Lesotho",
        "LI" => "Liberia",
        "LY" => "Libya",
        "LH" => "Lithuania",
        "LU" => "Luxembourg",
        "MC" => "Macau",
        "MK" => "Macedonia",
        "MA" => "Madagascar",
        "MI" => "Malawi",
        "MY" => "Malaysia",
        "MV" => "Maldives",
        "ML" => "Mali",
        "MT" => "Malta",
        "RM" => "Marshall Islands",
        "MB" => "Martinique",
        "MR" => "Mauritania",
        "MP" => "Mauritius",
        "MF" => "Mayotte",
        "MX" => "Mexico",
        "FM" => "Micronesia Federated States of",
        "MQ" => "Midway Islands",
        "MD" => "Moldova",
        "MN" => "Monaco",
        "MG" => "Mongolia",
        "YO" => "Montenegro",
        "MH" => "Montserrat",
        "MO" => "Morocco",
        "MZ" => "Mozambique",
        "WA" => "Nambia",
        "NR" => "Nauru",
        "BQ" => "Navassa Island",
        "NP" => "Nepal",
        "NL" => "Netherlands",
        "NT" => "Netherlands Antilles",
        "NC" => "New Caledonia",
        "NZ" => "New Zealand",
        "NU" => "Nicaragua",
        "NG" => "Niger",
        "NI" => "Nigeria",
        "NE" => "Niue",
        "NF" => "Norfolk Island",
        "UK" => "Northern Ireland",
        "CQ" => "Northern Mariana Islands",
        "NO" => "Norway",
        "MU" => "Oman",
        "OC" => "Other Countries",
        "PK" => "Pakistan",
        "LQ" => "Palmyra Atoll",
        "PM" => "Panama",
        "PP" => "Papua New Guinea",
        "PF" => "Paracel Islands",
        "PA" => "Paraguay",
        "PE" => "Peru",
        "RP" => "Philippines",
        "PC" => "Pitcairn Island",
        "PL" => "Poland",
        "PO" => "Portugal",
        "QA" => "Qatar",
        "RE" => "Reunion",
        "RH" => "Rhodesia",
        "RO" => "Romania",
        "RS" => "Russia",
        "RW" => "Rwanda",
        "SM" => "San Marino",
        "TP" => "Sao Tome and Principe",
        "SA" => "Saudi Arabia",
        "SG" => "Senegal",
        "SR" => "Serbia",
        "SE" => "Seychelles",
        "SL" => "Sierra Leone",
        "SN" => "Singapore",
        "LO" => "Slovakia",
        "SI" => "Slovenia",
        "BP" => "Solomon Islands",
        "SO" => "Somalia",
        "SF" => "South Africa",
        "SX" => "South Georgia and the South Sandwich Islands",
        "SP" => "Spain",
        "PG" => "Spratly Islands",
        "CE" => "Sri Lanka",
        "SH" => "St Helena",
        "SC" => "St Kitts and Nevis",
        "ST" => "St Lucia",
        "SB" => "St Pierre and Miquelon",
        "VC" => "St Vincent and the Grenadines",
        "SU" => "Sudan",
        "NS" => "Suriname",
        "SV" => "Svalbard",
        "WZ" => "Swaziland",
        "SW" => "Sweden",
        "SZ" => "Switzerland",
        "SY" => "Syria",
        "TW" => "Taiwan",
        "TI" => "Tajikistan",
        "TZ" => "Tanzania United Republic of",
        "TH" => "Thailand",
        "TL" => "Tokelau",
        "TN" => "Tonga",
        "TO" => "Tongo",
        "TT" => "Trinidad and Tobago",
        "TE" => "Tromelin",
        "PS" => "Trust Territory of the Pacific Islands",
        "TS" => "Tunisia",
        "TU" => "Turkey",
        "TX" => "Turkmenistan",
        "TK" => "Turks and Caicos Islands",
        "TV" => "Tuvalu",
        "UG" => "Uganda",
        "UP" => "Ukraine",
        "TC" => "United Arab Emirates",
        "UK" => "United Kingdom",
        "UY" => "Uruguay",
        "UZ" => "Uzbekistan",
        "NH" => "Vanuatu",
        "VT" => "Vatican City",
        "VE" => "Venezuela",
        "VM" => "Vietnam",
        "VI" => "Virgin Islands (British)",
        "WQ" => "Wake Island",
        "WF" => "Wallis and Futuna",
        "WE" => "West Bank",
        "WI" => "Western Sahara",
        "WS" => "Western Samoa",
        "YM" => "Yemen",
        "CG" => "Zaire",
        "ZA" => "Zambia",
        "ZI" => "Zimbabwe"
      }
      # All the countries included in the country_options output.
      COUNTRIES = ["Afghanistan", "Aland Islands", "Albania", "Algeria", "American Samoa", "Andorra", "Angola",
        "Anguilla", "Antarctica", "Antigua And Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria",
        "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin",
        "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegowina", "Botswana", "Bouvet Island", "Brazil",
        "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia",
        "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China",
        "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo",
        "Congo, the Democratic Republic of the", "Cook Islands", "Costa Rica", "Cote d'Ivoire", "Croatia", "Cuba",
        "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt",
        "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)",
        "Faroe Islands", "Fiji", "Finland", "France", "French Guiana", "French Polynesia",
        "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guernsey", "Guinea",
        "Guinea-Bissau", "Guyana", "Haiti", "Heard and McDonald Islands", "Holy See (Vatican City State)",
        "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran, Islamic Republic of", "Iraq",
        "Ireland", "Isle of Man", "Israel", "Italy", "Jamaica", "Japan", "Jersey", "Jordan", "Kazakhstan", "Kenya",
        "Kiribati", "Korea, Democratic People's Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan",
        "Lao People's Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya",
        "Liechtenstein", "Lithuania", "Luxembourg", "Macao", "Macedonia, The Former Yugoslav Republic Of",
        "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique",
        "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of", "Moldova, Republic of",
        "Monaco", "Mongolia", "Montenegro", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru",
        "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger",
        "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau",
        "Palestinian Territory, Occupied", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines",
        "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation",
        "Rwanda", "Saint Barthelemy", "Saint Helena", "Saint Kitts and Nevis", "Saint Lucia",
        "Saint Pierre and Miquelon", "Saint Vincent and the Grenadines", "Samoa", "San Marino",
        "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore",
        "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa",
        "South Georgia and the South Sandwich Islands", "Spain", "Sri Lanka", "Sudan", "Suriname",
        "Svalbard and Jan Mayen", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic",
        "Taiwan", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Timor-Leste",
        "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan",
        "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom",
        "United States", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela",
        "Viet Nam", "Virgin Islands, British", "Virgin Islands, U.S.", "Wallis and Futuna", "Western Sahara",
        "Yemen", "Zambia", "Zimbabwe"] unless const_defined?("COUNTRIES")
    end

    class InstanceTag
      def to_country_select_tag(priority_countries, options, html_options)
        html_options = html_options.stringify_keys
        add_default_name_and_id(html_options)
        value = value(object)
        content_tag("select",
          add_options(
            country_options_for_select(value, priority_countries),
            options, value
          ), html_options
        )
      end
    end

    class FormBuilder
      def country_select(method, priority_countries = nil, options = {}, html_options = {})
        @template.country_select(@object_name, method, priority_countries, options.merge(:object => @object), html_options)
      end
    end
  end
end
