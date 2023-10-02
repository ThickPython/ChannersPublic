//
//  ChannersTests.swift
//  ChannersTests
//
//  Created by Rez on 4/12/23.
//

import XCTest
@testable import Channers

final class ChannersTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testHTTPRequest() throws {
        let exp = expectation(description: "closure works")
        
        let url = URL(string: "https://a.4cdn.org/lgbt/catalog.json")
        let urlRequest = URLRequest(url: url!)
        print("here")
        DataRequest.GetObjectDataArray(fromURL: url!, ofType: CatalogPageRaw.self) { catalog in
            
            
            exp.fulfill()
        } onFailure: { error in
            return
        }
        print("now here")
        
        waitForExpectations(timeout: 10)
    }
    
    func testSillyStupidClosures() throws {
        let exp = expectation(description: "closure works")
        
        let catalog = FeatureHandlers.GetCatalog(fromBoard: "lgbt") {
            catalog in
            print(catalog.pages.count)
            print("success")
            exp.fulfill()
        } onFailure: { error in
            print("failure")
        }
        
        waitForExpectations(timeout: 10)
    }
    
    func testCreateSections() throws {
        var tests : [String] = []
        
        let test1 = ####"<a href=\"#p612183\" class=\"quotelink\">&gt;&gt;612183</a><br><span class=\"quote\">&gt;BOX BOX</span>"####
        
        let test2 = ####"<a href=\"#p612183\" class=\"quotelink\">&gt;&gt;612183</a><br>Yup, no give, none, zero, zilch. When i move part to glue next flap to place i tear some finished piece. Gonna have to cut every part down to individual flat pieces, display angles and glue<br> them together face to face.<br><a href=\"#p612217\" class=\"quotelink\">&gt;&gt;612217</a><br>Patrik pls."####
        
        let test3 = ####"<a href=\"#p609298\" class=\"quotelink\">&gt;&gt;609298</a><br>amazing"####
        
        let test4 = ####"<b>FAQs about origami</b><br>\n<br>\n<i>Where do I begin with origami and how can I find easy models?</i><br>\n<br>\nTry browsing the board for guides, or other online resources listed below, for models you like and practice folding them.<br>\n<br>\nA great way to begin at origami is to participate in the Let’s Fold Together threads <a href=\"https://boards.4channel.org/po/catalog#s=lft\"><a href=\"//boards.4channel.org/po/catalog#s=lft\" class=\"quotelink\">&gt;&gt;&gt;/po/lft</a></a> - open up the PDF file and find a model you like, work on it, and discuss or post results.<br>\n<br>\n<a href=\"http://en.origami-club.com\">http://en.origami-club.com</a><br>\n<a href=\"https://origami.me/diagrams/\">https://origami.me/diagrams/</a><br>\n<a href=\"https://www.origami-resource-center.com/free-origami-instructions.html\">https://www.origami-resource-center<wbr>.com/free-origami-instructions.html<wbr></a><br>\n<a href=\"http://www.paperfolding.com/diagrams/\">http://www.paperfolding.com/diagram<wbr>s/</a><br>\n<br>\n<i>What paper should I use?</i><br>\n<br>\nIt depends on the model; for smaller models which involved 25 steps or fewer, 15 by 15 cm origami paper from a local craft store will be suitable. For larger models you will need larger or thinner paper, possibly from online shops. Boxpleated models require thin paper, such as sketching paper. Wet folded models require thicker paper, such as elephant hide.<br>\n<br>\n<a href=\"https://www.origami-shop.com/en/\">https://www.origami-shop.com/en/</a><br>\n<br>\n<i>Hints and tips?</i><br>\n<br>\nFor folding, The best advice is to always fold as cleanly as possible, and take your time. Everything else comes with experience.<br>\n<br>\n<a href=\"https://origami.me/beginners-guide/\">https://origami.me/beginners-guide/<wbr></a><br>\n<a href=\"https://origamiusa.org/glossary\">https://origamiusa.org/glossary</a><br>\n<br>\n<i>What are ‘CPs’?</i><br>\n<br>\nCrease patterns are a structural representations of origami models, shown as a schematic of lines; they are essentially origami models unfolded and laid flat. Lines on a crease pattern may be indicated by ‘mountain’ or ‘valley’ folds to show how the folds alternate. If you’re particularly skilled at origami, they become useful instructions for building models. A common base fold is usually discernable, all the intermediate details can be worked on from there.<br>\n<br>\n<a href=\"https://blog.giladnaor.com/2008/08/folding-from-crease-patterns.html\">https://blog.giladnaor.com/2008/08/<wbr>folding-from-crease-patterns.html</a><br>\n<a href=\"http://www.origamiaustria.at/articles.php?lang=2#a4\">http://www.origamiaustria.at/articl<wbr>es.php?lang=2#a4</a><br>"####
        
        tests.append(test1)
        tests.append(test2)
        tests.append(test3)
        tests.append(test4)
        
        tests.forEach({
            test in
            
            var cleaned = test.removingHTMLEntities()
            print("---------\n")
            print("---------\n")
        })
        
    }
    
    func testCreateTextComponents() throws {
        let test1 = """
                <b>FAQs about origami</b><br>\n<br>\n<i>Where do I begin with origami and how can I find easy models?</i><br>\n<br>\nTry browsing the board for guides, or other online resources listed below, for models you like and practice folding them.<br>\n<br>\nA great way to begin at origami is to participate in the Let’s Fold Together threads <a href=\"https://boards.4channel.org/po/catalog#s=lft\"><a href=\"//boards.4channel.org/po/catalog#s=lft\" class=\"quotelink\">>>>/po/lft</a></a> - open up the PDF file and find a model you like, work on it, and discuss or post results.<br>\n<br>\n
                """
        let test2 = """
                <br>Yup, no give, none, zero, zilch. When i move part to glue next flap to place i tear some finished piece. Gonna have to cut every part down to individual flat pieces, display angles and glue<br> them together face to face.<br>
"""
        let test3 = "textstart<span class=\"quote\">&gt;your letter</span><br><span class=\"quote\">&gt;your main</span><br>textmid<span class=\"quote\">&gt;your rank</span>text end<a href=\"#p4497277\" class=\"quotelink\">>>4497277</a>"
        
        var tests : [String] = []
        
        tests.append(test1)
        tests.append(test2)
        var commentView = CommentView(comment: test3)
        for test in tests {
            print(PlaintextHandler.ExtractTextComponents(fromString: test).toString())
        }
    }
    
    func testNewStructs() throws {
        let exp = expectation(description: "get catalog")
        var cataata : Catalog? = nil
        
        FeatureRequest.GrabCatalogAPI(ofBoard: "lgbt", onSuccess: {
            catalog in
            
            cataata = catalog
            
            exp.fulfill()
        }, onFailure: {
            error in
            
        })
        
        waitForExpectations(timeout: 20)
    }
    
    func testClosureWeirds() throws {
        let exp = expectation(description: "excuse")
        let cat = CatalogObj(board: "lgbt")
        cat.GetObj()
        wait(for: [exp], timeout: 10)
    }
}
