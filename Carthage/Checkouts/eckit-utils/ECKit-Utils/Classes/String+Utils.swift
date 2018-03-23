//
//  String+Utils.swift
//  ECKit-Utils
//
//  Created by Katekov, Anton on 2018/01/15.
//

import Foundation

private struct ForbiddenCharacter {
    let forbiddenCharacters: [String]
    let replacementCharacter: String
    
    func replace(from string: String) -> String {
        var result = string
        forbiddenCharacters.forEach { (character) in
            result = result.replacingOccurrences(of: character, with: self.replacementCharacter)
        }
        return result
    }
}

extension String {
    public func sanitizeURL() -> String {
        // F*ck the stupid API response!
        var url = self
        guard url != "" else {
            return url
        }
        if url.hasPrefix("http:") == false && url.hasPrefix("https://") == false {
            url = "http:" + url
        }
        return url
    }
    
    public func isValidURL() -> Bool {
        guard let _ = URL(string: self) else {
            return false
        }
        return true
    }
    
    public var ri_count: Int {
        return self.characters.count
    }
    
    private func rangesOfString(_ searchString: String, options: NSString.CompareOptions = [], searchRange: Range<Index>? = nil ) -> [Range<Index>] {
        if let range = range(of: searchString, options: options, range:searchRange) {
            let nextRange = range.upperBound..<self.endIndex
            return [range] + rangesOfString(searchString, searchRange: nextRange)
        } else {
            return []
        }
    }
    
    public func ri_NSRange(of searchString: String, options: NSString.CompareOptions = NSString.CompareOptions.caseInsensitive, searchRange: NSRange? = nil) -> [NSRange] {
        let nsSelf = self as NSString
        
        let range = nsSelf.range(of: searchString, options: options, range: searchRange ?? NSRange(location: 0, length: NSString(string: self).length))
        if range.location != NSNotFound {
            let nextRange = NSMakeRange(range.location + range.length, nsSelf.length - range.location - range.length)
            return [range] + ri_NSRange(of: searchString, searchRange: nextRange)
        } else {
            return []
        }
    }
    
    public typealias StringPainting = (texts: [String], attributes: [NSAttributedStringKey: Any])
    public func ri_paintTexts(paintingDicts: [StringPainting], baseAttributes: [NSAttributedStringKey: Any]? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        if let baseAttributes = baseAttributes {
            attributedString.addAttributes(baseAttributes, range: NSRange(location: 0, length: count))
        }
        for dict in paintingDicts {
            for text in dict.texts {
                let ranges = ri_NSRange(of: text)
                for range in ranges {
                    attributedString.addAttributes(dict.attributes, range: range)
                }
            }
        }
        return attributedString
    }
    
    public func ri_paintTexts(_ texts: [String], withAttributes attributes: [NSAttributedStringKey: Any], baseAttributes: [NSAttributedStringKey: Any]? = nil) -> NSAttributedString {
        let painting = (texts: texts, attributes: attributes)
        return ri_paintTexts(paintingDicts: [painting], baseAttributes: baseAttributes)
    }
    
    /**
     Add the link to specific text. This `NSAttirubtedString` text tapping will work
     only on UITextView that enable dataDetection.link mode.
     
     Link styling attributed will be applied by `UITextView.linkTextAttributes`.
     */
    public func ri_addLink(url: String, onText: String) -> NSAttributedString {
        let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.link: url]
        return self.ri_paintTexts([onText], withAttributes: attributes)
    }
    
    /**
     
     Initializer for String, converting interger value to string with seperator format.
     This will auto set minimumFractionDigits to 0.
     
     - parameter number: `Int` to be converted
     - parameter numberStyle: `NumberFormatter.Style` for style to be formatted.
     
     - Note: If the value cannot be formatted, empty string will be returned.
     
     */
    public init(number: Int, numberStyle: NumberFormatter.Style = .currency) {
        self = String(double: Double(number), numberStyle: .currency)
    }
    
    public init(double: Double,
                numberStyle: NumberFormatter.Style,
                minimumDigit: Int = 0,
                minimumFractionDigit: Int = 0,
                maximumFractionDigit: Int = 2,
                positivePrefix: String = "") {
        let formatter = NumberFormatter()
        formatter.numberStyle = numberStyle
        formatter.currencySymbol = ""
        formatter.currencyCode = ""
        formatter.minimumIntegerDigits = minimumDigit
        formatter.minimumFractionDigits = minimumFractionDigit
        formatter.maximumFractionDigits = maximumFractionDigit
        formatter.positivePrefix = positivePrefix
        if let formattedPrice = formatter.string(from: NSNumber(value: double)) {
            self = formattedPrice
        } else {
            self = ""
        }
    }
}

// MARK: - Regular Expression
extension String {
    
    public func validate(regex: String) -> Bool {
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        return test.evaluate(with: self)
    }
    
    public func ri_replacedForbiddenCharacters() -> String {
        let atSign = ForbiddenCharacter(forbiddenCharacters: ["＠", "﹫"], replacementCharacter: "@")
        return atSign.replace(from: self)
    }
    
    public var ri_removedHTMLTags: String {
        let htmlRegex = "<[^>]+>"
        return self.replacingOccurrences(of: htmlRegex, with: "", options: .regularExpression, range: nil)
    }
    public var ri_removedEndline: String {
        let newLineCharacter = "\n"
        return self.replacingOccurrences(of: newLineCharacter, with: "")
    }
}

public extension String {
    /**
     convert hexademical string to int.
     "#0000FF" -> 255
     
     if fails return nil
     */
    public var hex: UInt32? {
        var hexString = self
        if hexString.first == "#" {
            hexString = String(hexString.dropFirst())
        }
        var hexValue: UInt32 = 0
        if Scanner(string: hexString).scanHexInt32(&hexValue) {
            return hexValue
        }
        return nil
    }
}

public extension String {
    
    /// Adds percent encoding with given encoding
    public func ri_addingPercentEncoding(with encoding: String.Encoding) -> String {
        let encoded = CFURLCreateStringByAddingPercentEscapes(
            nil,
            self as CFString!,
            nil,
            "!*'();:@&=+$,/?#[]" as CFString!,
            CFStringConvertNSStringEncodingToEncoding(encoding.rawValue)
            ) as String
        return encoded
    }
    
    // Special case being used in [Report Inappropriate Item] on Item detail screen
    // since itemUrl, itemName, shopName is not displayed on webview (Report Inappropriate Item page)
    public static func encodeSpecialCharacters(string: String) -> String? {
        // https://developer.android.com/reference/java/net/URLEncoder.html
        // The alphanumeric characters "a" through "z", "A" through "Z" and "0" through "9" remain the same.
        var alphanumericWithSomeSign = CharacterSet()
        guard let lowerA = Unicode.Scalar("a"), let lowerZ = Unicode.Scalar("z"),
            let upperA = Unicode.Scalar("A"), let upperZ = Unicode.Scalar("Z"),
            let zero = Unicode.Scalar("0"), let nine = Unicode.Scalar("9") else {
                return nil
        }
        alphanumericWithSomeSign.insert(charactersIn: lowerA...lowerZ)
        alphanumericWithSomeSign.insert(charactersIn: upperA...upperZ)
        alphanumericWithSomeSign.insert(charactersIn: zero...nine)
        
        // The special characters ".", "-", "*", and "_" remain the same.
        alphanumericWithSomeSign.insert(charactersIn: ".-*_")
        // The space character " " is converted into a plus sign "+".
        let encodedSpaceString = " ".addingPercentEncoding(withAllowedCharacters: CharacterSet())
        
        var encodedString = string.addingPercentEncoding(withAllowedCharacters: alphanumericWithSomeSign)
        if let encodedSpaceString = encodedSpaceString {
            encodedString = encodedString?.replacingOccurrences(of: encodedSpaceString, with: "+")
        }
        
        return encodedString
    }
    
}
