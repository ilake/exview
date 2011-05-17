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
        "AF" =>        "Afghanistan",
        "AL" =>            "Albania",
        "DZ" =>            "Algeria",
        "AS" =>     "American Samoa",
        "AD" =>            "Andorra",
        "AO" =>             "Angola",

        "AI" =>           "Anguilla",
        "AQ" =>         "Antarctica",
        "AG" => "Antigua and Barbuda",
        "AR" =>          "Argentina",
        "AM" =>            "Armenia",
        "AW" =>              "Aruba",

        "AU" =>          "Australia",
        "AT" =>            "Austria",
        "AZ" =>        "Azerbaidjan",
        "BS" =>            "Bahamas",
        "BH" =>            "Bahrain",
        "BD" =>          "Banglades",
        "BB" =>           "Barbados",

        "BY" =>            "Belarus",
        "BE" =>            "Belgium",
        "BZ" =>             "Belize",
        "BJ" =>              "Benin",
        "BM" =>            "Bermuda",
        "BO" =>            "Bolivia",
        "BA" => "Bosnia-Herzegovina",

        "BW" =>           "Botswana",
        "BV" =>      "Bouvet Island",
        "BR" =>             "Brazil",
        "IO" => "British Indian O. Terr.",
        "BN" =>       "Brunei Darussalam",
        "BG" =>                "Bulgaria",

        "BF" =>            "Burkina Faso",
        "BI" =>                 "Burundi",
        "BT" =>                  "Buthan",
        "KH" =>                "Cambodia",
        "CM" =>                "Cameroon",
        "CA" =>                  "Canada",
        "CV" =>              "Cape Verde",

        "KY" =>          "Cayman Islands",
        "CF" =>    "Central African Rep.",
        "TD" =>                    "Chad",
        "CL" =>                   "Chile",
        "CN" =>                   "China",
        "CX" =>        "Christmas Island",

        "CC" =>    "Cocos (Keeling) Isl.",
        "CO" =>                "Colombia",
        "KM" =>                 "Comoros",
        "CG" =>                   "Congo",
        "CK" =>            "Cook Islands",
        "CR" =>              "Costa Rica",

        "HR" =>                 "Croatia",
        "CU" =>                    "Cuba",
        "CY" =>                  "Cyprus",
        "CZ" =>          "Czech Republic",
        "CS" =>          "Czechoslovakia",
        "DK" =>                 "Denmark",
        "DJ" =>                "Djibouti",

        "DM" =>                "Dominica",
        "DO" =>      "Dominican Republic",
        "TP" =>              "East Timor",
        "EC" =>                 "Ecuador",
        "EG" =>                   "Egypt",
        "SV" =>             "El Salvador",

        "GQ" =>       "Equatorial Guinea",
        "EE" =>                 "Estonia",
        "ET" =>                "Ethiopia",
        "FK" =>       "Falkland Isl.(UK)",
        "FO" =>           "Faroe Islands",
        "FJ" =>                    "Fiji",

        "FI" =>                 "Finland",
        "FR" =>                  "France",
        "FX" =>  "France (European Ter.)",
        "TF" =>   "French Southern Terr.",
        "GA" =>                   "Gabon",
        "GM" =>                  "Gambia",

        "GE" =>                 "Georgia",
        "DE" =>                 "Germany",
        "GH" =>                   "Ghana",
        "GI" =>               "Gibraltar",
        "GB" =>      "Great Britain (UK)",
        "GR" =>                  "Greece",
        "GL" =>               "Greenland",

        "GD" =>                 "Grenada",
        "GP" =>        "Guadeloupe (Fr.)",
        "GU" =>               "Guam (US)",
        "GT" =>               "Guatemala",
        "GN" =>                  "Guinea",
        "GW" =>           "Guinea Bissau",

        "GY" =>                  "Guyana",
        "GF" =>            "Guyana (Fr.)",
        "HT" =>                   "Haiti",
        "HM" =>   "Heard & McDonald Isl.",
        "HN" =>                "Honduras",
        "HK" =>               "Hong Kong",

        "HU" =>                 "Hungary",
        "IS" =>                 "Iceland",
        "IN" =>                   "India",
        "ID" =>               "Indonesia",
        "IR" =>                    "Iran",
        "IQ" =>                    "Iraq",
        "IE" =>                 "Ireland",
        "IL" =>                  "Israel",

        "IT" =>                   "Italy",
        "CI" =>             "Ivory Coast",
        "JM" =>                 "Jamaica",
        "JP" =>                   "Japan",
        "JO" =>                  "Jordan",
        "KZ" =>              "Kazachstan",
        "KE" =>                   "Kenya",

        "KG" =>               "Kirgistan",
        "KI" =>                "Kiribati",
        "KP" =>           "Korea (North)",
        "KR" =>           "Korea (South)",
        "KW" =>                  "Kuwait",
        "LA" =>                    "Laos",
        "LV" =>                  "Latvia",

        "LB" =>                 "Lebanon",
        "LS" =>                 "Lesotho",
        "LR" =>                 "Liberia",
        "LY" =>                   "Libya",
        "LI" =>           "Liechtenstein",
        "LT" =>               "Lithuania",
        "LU" =>              "Luxembourg",

        "MO" =>                   "Macau",
        "MG" =>              "Madagascar",
        "MW" =>                  "Malawi",
        "MY" =>                "Malaysia",
        "MV" =>                "Maldives",
        "ML" =>                    "Mali",
        "MT" =>                   "Malta",

        "MH" =>        "Marshall Islands",
        "MQ" =>        "Martinique (Fr.)",
        "MR" =>              "Mauritania",
        "MU" =>               "Mauritius",
        "MX" =>                  "Mexico",
        "FM" =>              "Micronesia",

        "MD" =>                "Moldavia",
        "MC" =>                  "Monaco",
        "MN" =>                "Mongolia",
        "MS" =>              "Montserrat",
        "MA" =>                 "Morocco",
        "MZ" =>              "Mozambique",
        "MM" =>                 "Myanmar",

        "NA" =>                 "Namibia",
        "NR" =>                   "Nauru",
        "NP" =>                   "Nepal",
        "AN" =>     "Netherland Antilles",
        "NL" =>             "Netherlands",
        "NT" =>            "Neutral Zone",

        "NC" =>     "New Caledonia (Fr.)",
        "NZ" =>             "New Zealand",
        "NI" =>               "Nicaragua",
        "NE" =>                   "Niger",
        "NG" =>                 "Nigeria",
        "NU" =>                    "Niue",

        "NF" =>          "Norfolk Island",
        "MP" =>   "Northern Mariana Isl.",
        "NO" =>                  "Norway",
        "OM" =>                    "Oman",
        "PK" =>                "Pakistan",
        "PW" =>                   "Palau",

        "PA" =>                  "Panama",
        "PG" =>               "Papua New",
        "PY" =>                "Paraguay",
        "PE" =>                    "Peru",
        "PH" =>             "Philippines",
        "PN" =>                "Pitcairn",
        "PL" =>                  "Poland",

        "PF" =>         "Polynesia (Fr.)",
        "PT" =>                "Portugal",
        "PR" =>        "Puerto Rico (US)",
        "QA" =>                   "Qatar",
        "RE" =>           "Reunion (Fr.)",
        "RO" =>                 "Romania",

        "RU" =>      "Russian Federation",
        "RW" =>                  "Rwanda",
        "LC" =>             "Saint Lucia",
        "WS" =>                   "Samoa",
        "SM" =>              "San Marino",
        "SA" =>            "Saudi Arabia",

        "SN" =>                 "Senegal",
        "SC" =>              "Seychelles",
        "SL" =>            "Sierra Leone",
        "SG" =>               "Singapore",
        "SK" =>         "Slovak Republic",
        "SI" =>                "Slovenia",

        "SB" =>         "Solomon Islands",
        "SO" =>                 "Somalia",
        "ZA" =>            "South Africa",
        "SU" =>            "Soviet Union",
        "ES" =>                   "Spain",
        "LK" =>               "Sri Lanka",

        "SH" =>              "St. Helena",
        "PM" =>   "St. Pierre & Miquelon",
        "ST" =>   "St. Tome and Principe",
        "KN" => "St.Kitts Nevis Anguilla",

        "VC" => "St.Vincent & Grenadines",
        "SD" =>                   "Sudan",
        "SR" =>                "Suriname",
        "SJ" => "Svalbard & Jan Mayen Is",
        "SZ" =>               "Swaziland",
        "SE" =>                  "Sweden",

        "CH" =>             "Switzerland",
        "SY" =>                   "Syria",
        "TJ" =>             "Tadjikistan",
        "TW" =>                  "Taiwan",
        "TZ" =>                "Tanzania",
        "TH" =>                "Thailand",
        "TG" =>                    "Togo",

        "TK" =>                 "Tokelau",
        "TO" =>                   "Tonga",
        "TT" =>       "Trinidad & Tobago",
        "TN" =>                 "Tunisia",
        "TR" =>                  "Turkey",
        "TM" =>            "Turkmenistan",

        "TC" =>  "Turks & Caicos Islands",
        "TV" =>                  "Tuvalu",
        "UG" =>                  "Uganda",
        "UA" =>                 "Ukraine",
        "AE" =>    "United Arab Emirates",
        "GB" =>          "United Kingdom",

        "US" =>           "United States",
        "UY" =>                 "Uruguay",
        "UM" =>  "US Minor outlying Isl.",
        "UZ" =>              "Uzbekistan",
        "VU" =>                 "Vanuatu",
        "VA" =>      "Vatican City State",

        "VE" =>               "Venezuela",
        "VN" =>                 "Vietnam",
        "VG" =>"Virgin Islands (British)",
        "VI" =>     "Virgin Islands (US)",
        "WF" => "Wallis & Futuna Islands",

        "EH" =>          "Western Sahara",
        "YE" =>                   "Yemen",
        "YU" =>              "Yugoslavia",
        "ZR" =>                   "Zaire",
        "ZM" =>                  "Zambia",
        "ZW" =>  "Zimbabwe"
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
