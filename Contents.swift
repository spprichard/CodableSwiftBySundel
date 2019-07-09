import Foundation

let rawData = """
{
    "currency": "PLN",
    "rates": {
        "USD": 3.76,
        "EUR": 4.24,
        "SEK": 0.41
    }
}
""".data(using: .utf8)!

struct Currency: Decodable {
    var key: String
    
    init(_ key: String) {
        self.key = key
    }
}

struct ExchangeRate: Decodable {
    let currency: Currency
    let rate: Double
}

struct CurrencyConversion {
    var currency: Currency
    var exchangeRates: [ExchangeRate] {
        return rates.values
    }
    
    private var rates: ExchangeRate.List
}

private extension ExchangeRate {
    struct List: Decodable {
        let values: [ExchangeRate]
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let dictionary = try container.decode([String : Double].self)
            
            values = dictionary.map {key, value in
                print("k: \(key) v: \(value)")
                // There is an error here when decoding, "Expected to decode Dictionary<String, Any> but found a string/data instead."
                return ExchangeRate(currency: Currency(key), rate: value)
            }
        }
    }
}

let decoder = JSONDecoder()
let data = try decoder.decode(ExchangeRate.self, from: rawData)
