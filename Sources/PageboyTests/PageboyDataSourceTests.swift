//
//  PageboyDataSourceTests.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 15/02/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import XCTest
@testable import Pageboy

class PageboyDataSourceTests: PageboyTests {
    
    /// Test loading view controllers from the data source.
    func testPageboyViewControllerValidSetUp() {
        self.dataSource.numberOfPages = 1
        self.pageboyViewController.dataSource = self.dataSource
        
        XCTAssert(self.pageboyViewController.pageCount == 1,
                  "View Controllers were not successfully loaded from the data source.")
    }
    
    /// Test loading an empty view controller array from the data source.
    func testPageboyViewControllerEmptySetUp() {
        self.dataSource.numberOfPages = 0
        self.pageboyViewController.dataSource = self.dataSource
        
        XCTAssert(self.pageboyViewController.pageCount == 0,
                  "Empty view controller array not successfully loaded from the data source.")
    }
    
    /// Test loading a nil array from the data source.
    func testPageboyViewControllerNilSetUp() {
        self.pageboyViewController.dataSource = self.dataSource
        
        XCTAssertNil(self.pageboyViewController.currentViewController,
                  "Current view controller is not nil when data source returns nil.")
    }
    
    /// Test using the default .first PageIndex when nil returned
    /// in defaultPageIndex(forPageboyViewController:).
    func testPageboyViewControllerDefaultPageIndexDefault() {
        self.dataSource.numberOfPages = 3
        self.pageboyViewController.dataSource = self.dataSource
        
        let expectation = XCTestExpectation(description: "Default page index is correct.")
        let waitTime = 0.1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
            XCTAssert(self.pageboyViewController.currentIndex == 0,
                      "Default Page index is not using correct .first PageIndex when no value is returned.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: waitTime * 2)
    }
    
    /// Test using a custom PageIndex when returned
    /// in defaultPageIndex(forPageboyViewController:).
    func testPageboyViewControllerDefaultPageIndexCustom() {
        self.dataSource.numberOfPages = 3
        self.dataSource.defaultIndex = .at(index: 1)
        self.pageboyViewController.dataSource = self.dataSource
        
        let expectation = XCTestExpectation(description: "Default page index is correct when specified.")
        let waitTime = 0.1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
            XCTAssert(self.pageboyViewController.currentIndex == 1,
                      "Default page index is not using correct index when specified.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: waitTime * 2)
    }
    
    /// Test using a custom out of range PageIndex when returned
    /// in defaultPageIndex(forPageboyViewController:).
    func testPageboyViewControllerDefaultPageIndexOutOfRange() {
        self.dataSource.numberOfPages = 3
        self.dataSource.defaultIndex = .at(index: 4)
        self.pageboyViewController.dataSource = self.dataSource
        
        XCTAssertNil(self.pageboyViewController.currentIndex,
                  "Default page index is not correctly erroring when out of range index specified.")
    }
    
    /// Test using an invalid .next PageIndex when returned
    /// in defaultPageIndex(forPageboyViewController:).
    func testPageboyViewControllerDefaultPageIndexInvalid() {
        self.dataSource.numberOfPages = 3
        self.dataSource.defaultIndex = .next
        self.pageboyViewController.dataSource = self.dataSource
        
        let expectation = XCTestExpectation(description: "Default page index is correct when invalid index specified.")
        let waitTime = 0.1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
            XCTAssert(self.pageboyViewController.currentIndex == 0,
                      "Default page index is not correctly handling an invalid index specified.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: waitTime * 2)
    }
    
    /// Test using .first PageIndex when returned
    /// in defaultPageIndex(forPageboyViewController:).
    func testPageboyViewControllerDefaultPageIndexFirst() {
        self.dataSource.numberOfPages = 3
        self.dataSource.defaultIndex = .first
        self.pageboyViewController.dataSource = self.dataSource
        
        let expectation = XCTestExpectation(description: "Default page index is correct when using .first.")
        let waitTime = 0.1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
            XCTAssert(self.pageboyViewController.currentIndex == 0,
                      "Default Page index is not using correct .first PageIndex when specified.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: waitTime * 2)
    }
    
    /// Test using .last PageIndex when returned
    /// in defaultPageIndex(forPageboyViewController:).
    func testPageboyViewControllerDefaultPageIndexLast() {
        self.dataSource.numberOfPages = 3
        self.dataSource.defaultIndex = .last
        self.pageboyViewController.dataSource = self.dataSource
        
        let expectation = XCTestExpectation(description: "Default page index is correct when using .last.")
        let waitTime = 0.1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
            XCTAssert(self.pageboyViewController.currentIndex == 2,
                      "Default Page index is not using correct .last PageIndex when specified.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: waitTime * 2)
    }
    
    /// Test whether reloadPages fully reloads 
    /// PageboyViewController.
    func testPageboyViewControllerReloadBehavior() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        let initialPageCount = self.pageboyViewController.pageCount
        
        self.dataSource.numberOfPages = 3
        self.pageboyViewController.reloadData()
        let reloadPageCount = self.pageboyViewController.pageCount
        
        XCTAssert(initialPageCount == 5 && reloadPageCount == 3,
                  "reloadPages is not correctly reloading view controllers.")
    }
    
    /// Test that reloadPages successfully calls 
    /// appropriate delegate function.
    func testPageboyViewControllerReloadDelegate() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource

        self.dataSource.numberOfPages = 3
        self.pageboyViewController.reloadData()
        
        let expectation = XCTestExpectation(description: "reloadPages calls didReloadViewControllers")
        let waitTime = 0.1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
            let reloadPageCount = self.delegate.lastDidReloadPageCount
            
            XCTAssertTrue(reloadPageCount == 3,
                          "reloadPages does not call didReloadViewControllers delegate function.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: waitTime * 2)
    }
    
    /// Test that reloadCurrentPageSoftly does not cause a data source reload.
    func testPageboyViewControllerSoftReloadBehavior() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        
        self.pageboyViewController.isInfiniteScrollEnabled = true
        
        let expectation = XCTestExpectation(description: "reloadCurrentPageSoftly doesn't reload data source")
        let waitTime = 0.1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
            XCTAssertTrue(self.delegate.reloadCount == 1,
                          "reloadCurrentPageSoftly causes the data source to reload")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: waitTime * 2)
    }
    
    /// Test that the UIPageViewController data source is 
    /// returning correct pageViewController:viewControllerAfter: values.
    func testPageViewControllerDataSourceNextController() {
        self.dataSource.numberOfPages = 3
        self.pageboyViewController.dataSource = self.dataSource
        
        let expectation = XCTestExpectation(description: "pageViewController:viewControllerAfter is correct")
        let waitTime = 0.1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
            let viewController = self.dataSource.viewControllers![0]
            let nextViewController = self.pageboyViewController.pageViewController(self.pageboyViewController.pageViewController!,
                                                                                   viewControllerAfter: viewController)
            
            XCTAssert(nextViewController === self.dataSource.viewControllers?[1],
                      "pageViewController:viewControllerAfter is returning an incorrect view controller")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: waitTime * 2)
    }
    
    /// Test that the UIPageViewController data source is
    /// returning nil from pageViewController:viewControllerAfter: at the end of the pages.
    func testPageViewControllerDataSourceNilNextController() {
        self.dataSource.numberOfPages = 3
        self.dataSource.defaultIndex = .last
        self.pageboyViewController.dataSource = self.dataSource
        
        let viewController = self.dataSource.viewControllers![2]
        let nextViewController = self.pageboyViewController.pageViewController(self.pageboyViewController.pageViewController!,
                                                                               viewControllerAfter: viewController)
        
        XCTAssertNil(nextViewController,
                  "pageViewController:viewControllerAfter is returning an incorrect view controller when at the end of pages.")
    }
    
    /// Test that the UIPageViewController data source is
    /// returning correct pageViewController:viewControllerBefore: values.
    func testPageViewControllerDataSourcePreviousController() {
        self.dataSource.numberOfPages = 3
        self.dataSource.defaultIndex = .at(index: 1)
        self.pageboyViewController.dataSource = self.dataSource
        
        let expectation = XCTestExpectation(description: "pageViewController:viewControllerBefore is correct")
        let waitTime = 0.1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
            let viewController = self.dataSource.viewControllers![1]
            let previousViewController = self.pageboyViewController.pageViewController(self.pageboyViewController.pageViewController!,
                                                                                       viewControllerBefore: viewController)
            
            XCTAssert(previousViewController === self.dataSource.viewControllers?[0],
                      "pageViewController:viewControllerBefore is returning an incorrect view controller")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: waitTime * 2)
    }
    
    /// Test that the UIPageViewController data source is
    /// returning nil from pageViewController:viewControllerBefore: at the start of the pages.
    func testPageViewControllerDataSourceNilPreviousController() {
        self.dataSource.numberOfPages = 3
        self.pageboyViewController.dataSource = self.dataSource
        
        let viewController = self.dataSource.viewControllers![0]
        let previousViewController = self.pageboyViewController.pageViewController(self.pageboyViewController.pageViewController!,
                                                                               viewControllerBefore: viewController)
        
        XCTAssertNil(previousViewController,
                  "pageViewController:viewControllerBefore is returning an incorrect view controller when at the start of pages.")
    }
}
