//
//  GithubSearchReactor.swift
//  GitHubReactorExample
//
//  Created by bear2u on 2017. 10. 14..
//  Copyright © 2017년 bear2u. All rights reserved.
//

import Foundation
import RxSwift
import ReactorKit

class GithubSearchReactor: Reactor {
    let titlesArray = ["Hello", "Swift", "programming"]
    
    var initialState = State()
    
    enum Action {
        case updateQuery(String?)
    }
    
    enum Mutation {
        case setQuery(String?)
        case setRepos([String] , nextPage : Int?)
        case setLoading(Bool)
    }
    
    struct State {
        var query : String?
        var titles : [String] = []
        var nextPage : Int?
        var isLoading : Bool = false
    }
    
    func mutate(action : Action) ->Observable<Mutation> {
        switch action {
        case let .updateQuery(query):
            print("~~mutate query");
            return Observable.concat(
                Observable.just(Mutation.setLoading(false)).delay(3, scheduler: MainScheduler.instance),
                Observable.just(Mutation.setRepos(titlesArray, nextPage: 0)),
                Observable.just(Mutation.setLoading(true))
            )
            
        }
    }
    
    func reduce(state: GithubSearchReactor.State, mutation: GithubSearchReactor.Mutation) -> GithubSearchReactor.State {
        switch mutation {
        case let .setRepos(repos , nextPage):
            var newState = state
            newState.titles = repos
            newState.nextPage = nextPage
            return newState
        case let .setQuery(_):
            return state
        case let .setLoading(isLoading) :
            var newState = state
            newState.isLoading = isLoading
            return newState
        }
    }
    
}
