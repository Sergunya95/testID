//
//  Parser.swift
//  InstaDev
//
//  Created by apple on 13.06.2022.
//

import Foundation

struct Parser {
    
    func getList(completion: @escaping (Hotels) -> Void) { 
        let request = URL(string: "https://bitbucket.org/instadevteam/tests/raw/63a9ecea18ca79c275a2eeafd95bc37f857cf2ec/1.2/0777.json")
        let task = URLSession.shared.dataTask(with: request!) { data, response, error in
            if let data = data, let result = try? JSONDecoder().decode(Hotels.self, from: data) {
                completion(result)
            } else {
                completion([])
            }
        }
        task.resume()
    }
}
