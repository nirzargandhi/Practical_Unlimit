//
//  JokesDBManager.swift
//

import FMDB
import ObjectiveC

let sharedInstance = JokesDBManager()

//MARK: - JokesDBManager
class JokesDBManager: NSObject {

    //MARK: - Variable Declaration
    var database: FMDatabase? = nil

    //MARK: - Database Methods
    class func getInstance() -> JokesDBManager {

        if(sharedInstance.database == nil) {
            sharedInstance.database = FMDatabase(path: Utility().getPath(fileName: "JokesDB.sqlite"))
        }

        return sharedInstance
    }

    func addJokesData(objJokesList: JokesList) -> Bool {

        sharedInstance.database!.open()

        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO tblJokes (joke, date) VALUES (?, ?)", withArgumentsIn: [objJokesList.joke as Any, objJokesList.date as Any])

        if !isInserted {
            print(sharedInstance.database?.lastErrorMessage() as Any)
        }

        sharedInstance.database!.close()

        return isInserted
    }

    func deleteJokesData(objJokesList: JokesList) -> Bool {

        sharedInstance.database!.open()

        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM tblJokes WHERE date=?", withArgumentsIn: [objJokesList.date as Any])

        sharedInstance.database!.close()

        return isDeleted
    }

    func getAllJokesData() -> [JokesList] {

        sharedInstance.database!.open()

        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM tblJokes", withArgumentsIn:[])

        var arrJokesList : [JokesList] = [JokesList]()

        if (resultSet != nil) {

            while resultSet.next() {

                let objJokesList : JokesList = JokesList(joke: resultSet.string(forColumn: "joke") ?? "", date: resultSet.string(forColumn: "date") ?? "")

                arrJokesList.append(objJokesList)
            }
        }

        sharedInstance.database!.close()

        return arrJokesList
    }
}
