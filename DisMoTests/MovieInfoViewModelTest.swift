//
//  MovieInfoViewModelTest.swift
//  DisMoTests
//
//  Created by Macbook on 19/12/22.
//

import Quick
import Nimble
@testable import DisMo

class KoinBillPulsaViewModelTest: QuickSpec {
    
    var viewModel: MovieInfoViewModel!
    var service: MockDismoServices!
    var mockResponses = MockResponse()
    
    override func spec() {
        describe("test fetch reviews functions") {
            beforeEach {
                self.service = MockDismoServices()
                self.viewModel = MovieInfoViewModel(service: self.service, movieDetail: MovieDetail())
                self.mockResponses = MockResponse()
            }
            
            it("successfuly get reviews") {
                let response = self.mockResponses.successGetReviews
                let data = response.data(using: .utf8)!
                self.service.response = try? JSONSerialization.jsonObject(
                    with: data,
                    options: [])
                self.viewModel.getReviews()
                
                // Assert value on viewmodel
                expect(self.viewModel.reviewResponse.value).toNot(beNil())
            }
            
            it("failed get reviews") {
                let response = ""
                let data = response.data(using: .utf8)!
                self.service.response = try? JSONSerialization.jsonObject(
                    with: data,
                    options: [])
                self.viewModel.getReviews()
                
                // Assert value on viewmodel
                expect(self.viewModel.reviewResponse.value).to(beNil())
                expect(self.viewModel.error.value).toNot(beNil())
            }
        }
    }
}
