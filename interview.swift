import Foundation

/**
 The task is to implement the Library protocol (you can do that in this file directly).
 - No database or any other storage is required, just store data in memory
 - No any smart search, use String method contains (case sensitive/insensitive - does not matter)
 –   Performance optimizations for listBooksByName and listBooksByAuthor are optional
 */

struct Book {
    let id: String; // unique identifier
    let name: String;
    let author: String;
}

protocol Library {
    /**
     Adds a new book object to the Library.
     - Parameter book: book to add to the Library
     - Returns: false if the book with same id already exists in the Library, true – otherwise.
     */
    func addNewBook(book: Book) -> Bool;
    
    /**
     Deletes the book with the specified id from the Library.
     - Returns: true if the book with same id existed in the Library, false – otherwise.
     */
    func deleteBook(id: String) -> Bool;
    
    /**
     - Returns: 10 book names containing the specified string.
     If there are several books with the same name, author's name is added to book's name in the format "<author> - <book>",
     otherwise returns simply "<book>".
     */
    func listBooksByName(searchString: String) -> Set<String>;
    
    /**
     - Returns: 10 book names whose author contains the specified string,
     result is ordered by authors.
     */
    func listBooksByAuthor(searchString: String) -> [String];
}

// TODO: your implementation goes here
class LibraryImpl: Library {
    
    var bookList: Dictionary<String, Book> = [:]
    
    func addNewBook(book: Book) -> Bool {
        guard let _ = bookList[book.id] else {
            self.bookList[book.id] = book
            return true
        }
        return false
    }
    
    func deleteBook(id: String) -> Bool {
        guard let _ = bookList[id] else {
            return false
        }
        self.bookList.removeValue(forKey: id)
        return true
    }
    
    func listBooksByName(searchString: String) -> Set<String> {
        
        var result: Set<String> = []
        
        for book in self.bookList {
            if book.value.name.contains(searchString) {
                if self.bookList.filter({ $0.value.name == book.value.name }).count != 1 {
                    result.insert("\(book.value.author) - \(book.value.name)")
                } else {
                    result.insert(book.value.name)
                }
            }
        }
        
        return Set<String>(result.prefix(10))
    }
    
    func listBooksByAuthor(searchString: String) -> [String] {
        
        var result: [String] = []
        
        let sortedBook = self.bookList.sorted(by: { $0.key < $1.key })
        
        for book in sortedBook {
            if book.value.author.contains(searchString) {
                result.append(book.value.name)
            }
        }
        return Array(result.prefix(10))
    }
    
}

func test(lib: Library) {
    assert(!lib.deleteBook(id: "1"))
    assert(lib.addNewBook(book: Book(id: "1", name: "1", author: "Lex")))
    assert(!lib.addNewBook(book: Book(id: "1", name: "any name because we check id only", author: "any author")))
    assert(lib.deleteBook(id: "1"))
    assert(lib.addNewBook(book: Book(id: "3", name: "Some Book3", author: "Some Author2")))
    assert(lib.addNewBook(book: Book(id: "4", name: "Some Book1", author: "Some Author3")))
    assert(lib.addNewBook(book: Book(id: "2", name: "Some Book2", author: "Some Author2")))
    assert(lib.addNewBook(book: Book(id: "1", name: "Some Book1", author: "Some Author1")))
    assert(lib.addNewBook(book: Book(id: "5", name: "Other Book5", author: "Other Author4")))
    assert(lib.addNewBook(book: Book(id: "6", name: "Other Book6", author: "Other Author4")))
    assert(lib.addNewBook(book: Book(id: "7", name: "Other Book7", author: "Other Author4")))
    assert(lib.addNewBook(book: Book(id: "8", name: "Other Book8", author: "Other Author4")))
    assert(lib.addNewBook(book: Book(id: "9", name: "Other Book9", author: "Other Author4")))
    assert(lib.addNewBook(book: Book(id: "10", name: "Other Book10", author: "Other Author4")))
    assert(lib.addNewBook(book: Book(id: "11", name: "Other Book11", author: "Other Author4")))
    
    var byNames: Set<String> = lib.listBooksByName(searchString: "Book")
    assert(byNames.count == 10)
    byNames = lib.listBooksByName(searchString: "Some Book")
    assert(byNames.count == 4)
    assert(byNames.contains("Some Author3 - Some Book1"))
    assert(byNames.contains("Some Book2"))
    assert(byNames.contains("Some Book3"))
    assert(!byNames.contains("Some Book1"))
    assert(byNames.contains("Some Author1 - Some Book1"))

    var byAuthor: [String] = lib.listBooksByAuthor(searchString: "Author")
    assert(byAuthor.count == 10)
    byAuthor = lib.listBooksByAuthor(searchString: "Some Author")
    assert(byAuthor.count == 4)
    print(byAuthor)
    assert(byAuthor[0] == "Some Book1")
    assert(byAuthor[1] == "Some Book2" || byAuthor[1] == "Some Book3")
    assert(byAuthor[2] == "Some Book2" || byAuthor[2] == "Some Book3")
    assert(byAuthor[3] == "Some Book1")
}

test(lib: LibraryImpl())
