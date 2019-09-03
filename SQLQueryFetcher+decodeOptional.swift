//
//  SQLQueryFetcher+decodeOptional.swift
//  KognitaCore
//
//  Created by Mats Mollestad on 9/2/19.
//

import SQL
import PostgreSQL

extension SQLQueryFetcher {
    
    /// Collects the first decoded output and returns it.
    ///
    ///     builder.first(decoding: Planet.self)
    ///
    public func first<D>(decoding type: Optional<D>.Type) -> Future<D?>
        where D: Decodable
    {
        return self.all(decoding: type).map { $0.first }
    }
    
    /// Collects the first decoded output and returns it.
    ///
    ///     builder.first(decoding: Planet.self)
    ///
    public func first<A, B>(decoding typeA: Optional<A>.Type, _ typeB: Optional<B>.Type) -> Future<(A?, B?)?>
        where A: Decodable, B: Decodable
    {
        return self.all(decoding: typeA, typeB).map { $0.first }
    }
    
    /// Collects the first decoded output and returns it.
    ///
    ///     builder.first(decoding: Planet.self)
    ///
    public func first<A, B>(decoding typeA: A.Type, _ typeB: Optional<B>.Type) -> Future<(A, B?)?>
        where A: Decodable, B: Decodable
    {
        return self.all(decoding: typeA, typeB).map { $0.first }
    }

    /// Collects the first decoded output and returns it.
    ///
    ///     builder.first(decoding: Planet.self)
    ///
    public func first<A, B, C>(decoding typeA: Optional<A>.Type, _ typeB: Optional<B>.Type, _ typeC: Optional<C>.Type) -> Future<(A?, B?, C?)?>
        where A: Decodable, B: Decodable, C: Decodable
    {
        return self.all(decoding: typeA, typeB, typeC).map { $0.first }
    }
    
    /// Collects the first decoded output and returns it.
    ///
    ///     builder.first(decoding: Planet.self)
    ///
    public func first<A, B, C>(decoding typeA: A.Type, _ typeB: Optional<B>.Type, _ typeC: Optional<C>.Type) -> Future<(A, B?, C?)?>
        where A: Decodable, B: Decodable, C: Decodable
    {
        return self.all(decoding: typeA, typeB, typeC).map { $0.first }
    }
    
    /// Collects the first decoded output and returns it.
    ///
    ///     builder.first(decoding: Planet.self)
    ///
    public func first<A, B, C>(decoding typeA: A.Type, _ typeB: B.Type, _ typeC: Optional<C>.Type) -> Future<(A, B, C?)?>
        where A: Decodable, B: Decodable, C: Decodable
    {
        return self.all(decoding: typeA, typeB, typeC).map { $0.first }
    }
    
    /// Collects all decoded output into an array and returns it.
    ///
    ///     builder.all(decoding: Planet.self)
    ///
    public func all<A>(decoding type: Optional<A>.Type) -> Future<[A]>
        where A: Decodable
    {
        var all: [A] = []
        return run(decoding: type) {
            if let element = $0 {
                all.append(element)
            }
        }.map { all }
    }
    
    /// Collects all decoded output into an array and returns it.
    ///
    ///     builder.all(decoding: Planet.self)
    ///
    public func all<A, B>(decoding typeA: Optional<A>.Type, _ typeB: Optional<B>.Type) -> Future<[(A?, B?)]>
        where A: Decodable, B: Decodable
    {
        var all: [(A?, B?)] = []
        return run(decoding: typeA, typeB) { aValue, bValue in
            if aValue != nil || bValue != nil {
                all.append((aValue, bValue))
            }
        }.map { all }
    }
    
    /// Collects all decoded output into an array and returns it.
    ///
    ///     builder.all(decoding: Planet.self)
    ///
    public func all<A, B>(decoding typeA: A.Type, _ typeB: Optional<B>.Type) -> Future<[(A, B?)]>
        where A: Decodable, B: Decodable
    {
        var all: [(A, B?)] = []
        return run(decoding: typeA, typeB) { aValue, bValue in all.append((aValue, bValue)) }.map { all }
    }
    
    /// Collects all decoded output into an array and returns it.
    ///
    ///     builder.all(decoding: Planet.self)
    ///
    public func all<A, B, C>(decoding typeA: Optional<A>.Type, _ typeB: Optional<B>.Type, _ typeC: Optional<C>.Type) -> Future<[(A?, B?, C?)]>
        where A: Decodable, B: Decodable, C: Decodable
    {
        var all: [(A?, B?, C?)] = []
        return run(decoding: typeA, typeB, typeC) { aValue, bValue, cValue in
            if aValue != nil || bValue != nil || cValue != nil {
                all.append((aValue, bValue, cValue))
            }
        }.map { all }
    }
    
    /// Collects all decoded output into an array and returns it.
    ///
    ///     builder.all(decoding: Planet.self)
    ///
    public func all<A, B, C>(decoding typeA: A.Type, _ typeB: Optional<B>.Type, _ typeC: Optional<C>.Type) -> Future<[(A, B?, C?)]>
        where A: Decodable, B: Decodable, C: Decodable
    {
        var all: [(A, B?, C?)] = []
        return run(decoding: typeA, typeB, typeC) { aValue, bValue, cValue in all.append((aValue, bValue, cValue)) }.map { all }
    }
    
    /// Collects all decoded output into an array and returns it.
    ///
    ///     builder.all(decoding: Planet.self)
    ///
    public func all<A, B, C>(decoding typeA: A.Type, _ typeB: B.Type, _ typeC: Optional<C>.Type) -> Future<[(A, B, C?)]>
        where A: Decodable, B: Decodable, C: Decodable
    {
        var all: [(A, B, C?)] = []
        return run(decoding: typeA, typeB, typeC) { aValue, bValue, cValue in all.append((aValue, bValue, cValue)) }.map { all }
    }
    
    /// Runs the query, passing decoded output to the supplied closure as it is recieved.
    ///
    ///     builder.run(decoding: Planet.self) { planet in
    ///         // ..
    ///     }
    ///
    /// The returned future will signal completion of the query.
    public func run<A>(
        decoding type: Optional<A>.Type,
        into handler: @escaping (A?) throws -> ()
    ) -> Future<Void>
        where A: Decodable
    {
        return connectable.withSQLConnection { conn in
            return conn.query(self.query) { row in
                let identifier = Connectable.Connection.Query.Select.TableIdentifier.table(any: A.self)
                let dValue = conn.decodeOptional(type, from: row, table: identifier)
                try handler(dValue)
            }
        }
    }
    
    /// Runs the query, passing decoded output to the supplied closure as it is recieved.
    ///
    ///     builder.run(decoding: Planet.self, Galaxy.self, SolarSystem.self) { planet, galaxy, solarSystem in
    ///         // ..
    ///     }
    ///
    /// The returned future will signal completion of the query.
    public func run<A, B>(
        decoding aType: Optional<A>.Type, _ bType: Optional<B>.Type,
        into handler: @escaping (A?, B?) throws -> ()
    ) -> Future<Void>
        where A: Decodable, B: Decodable
    {
        return connectable.withSQLConnection { conn in
            return conn.query(self.query) { row in
                let identifierA = Connectable.Connection.Query.Select.TableIdentifier.table(any: A.self)
                let identifierB = Connectable.Connection.Query.Select.TableIdentifier.table(any: B.self)
                let aValue = conn.decodeOptional(aType, from: row, table: identifierA)
                let bValue = conn.decodeOptional(bType, from: row, table: identifierB)
                try handler(aValue, bValue)
            }
        }
    }
    
    /// Runs the query, passing decoded output to the supplied closure as it is recieved.
    ///
    ///     builder.run(decoding: Planet.self, Galaxy.self, SolarSystem.self) { planet, galaxy, solarSystem in
    ///         // ..
    ///     }
    ///
    /// The returned future will signal completion of the query.
    public func run<A, B>(
        decoding aType: A.Type, _ bType: Optional<B>.Type,
        into handler: @escaping (A, B?) throws -> ()
    ) -> Future<Void>
        where A: Decodable, B: Decodable
    {
        return connectable.withSQLConnection { conn in
            return conn.query(self.query) { row in
                let identifierA = Connectable.Connection.Query.Select.TableIdentifier.table(any: A.self)
                let identifierB = Connectable.Connection.Query.Select.TableIdentifier.table(any: B.self)
                let aValue = try conn.decode(aType, from: row, table: identifierA)
                let bValue = conn.decodeOptional(bType, from: row, table: identifierB)
                try handler(aValue, bValue)
            }
        }
    }
    
    /// Runs the query, passing decoded output to the supplied closure as it is recieved.
    ///
    ///     builder.run(decoding: Planet.self, Galaxy.self, SolarSystem.self) { planet, galaxy, solarSystem in
    ///         // ..
    ///     }
    ///
    /// The returned future will signal completion of the query.
    public func run<A, B, C>(
        decoding aType: Optional<A>.Type, _ bType: Optional<B>.Type, _ cType: Optional<C>.Type,
        into handler: @escaping (A?, B?, C?) throws -> ()
    ) -> Future<Void>
        where A: Decodable, B: Decodable, C: Decodable
    {
        return connectable.withSQLConnection { conn in
            return conn.query(self.query) { row in
                let identifierA = Connectable.Connection.Query.Select.TableIdentifier.table(any: A.self)
                let identifierB = Connectable.Connection.Query.Select.TableIdentifier.table(any: B.self)
                let identifierC = Connectable.Connection.Query.Select.TableIdentifier.table(any: C.self)
                let aValue = conn.decodeOptional(aType, from: row, table: identifierA)
                let bValue = conn.decodeOptional(bType, from: row, table: identifierB)
                let cValue = conn.decodeOptional(cType, from: row, table: identifierC)
                try handler(aValue, bValue, cValue)
            }
        }
    }
    
    /// Runs the query, passing decoded output to the supplied closure as it is recieved.
    ///
    ///     builder.run(decoding: Planet.self, Galaxy.self, SolarSystem.self) { planet, galaxy, solarSystem in
    ///         // ..
    ///     }
    ///
    /// The returned future will signal completion of the query.
    public func run<A, B, C>(
        decoding aType: A.Type, _ bType: Optional<B>.Type, _ cType: Optional<C>.Type,
        into handler: @escaping (A, B?, C?) throws -> ()
    ) -> Future<Void>
        where A: Decodable, B: Decodable, C: Decodable
    {
        return connectable.withSQLConnection { conn in
            return conn.query(self.query) { row in
                let identifierA = Connectable.Connection.Query.Select.TableIdentifier.table(any: A.self)
                let identifierB = Connectable.Connection.Query.Select.TableIdentifier.table(any: B.self)
                let identifierC = Connectable.Connection.Query.Select.TableIdentifier.table(any: C.self)
                let aValue = try conn.decode(aType, from: row, table: identifierA)
                let bValue = conn.decodeOptional(bType, from: row, table: identifierB)
                let cValue = conn.decodeOptional(cType, from: row, table: identifierC)
                try handler(aValue, bValue, cValue)
            }
        }
    }
    
    /// Runs the query, passing decoded output to the supplied closure as it is recieved.
    ///
    ///     builder.run(decoding: Planet.self, Galaxy.self, SolarSystem.self) { planet, galaxy, solarSystem in
    ///         // ..
    ///     }
    ///
    /// The returned future will signal completion of the query.
    public func run<A, B, C>(
        decoding aType: A.Type, _ bType: B.Type, _ cType: Optional<C>.Type,
        into handler: @escaping (A, B, C?) throws -> ()
    ) -> Future<Void>
        where A: Decodable, B: Decodable, C: Decodable
    {
        return connectable.withSQLConnection { conn in
            return conn.query(self.query) { row in
                let identifierA = Connectable.Connection.Query.Select.TableIdentifier.table(any: A.self)
                let identifierB = Connectable.Connection.Query.Select.TableIdentifier.table(any: B.self)
                let identifierC = Connectable.Connection.Query.Select.TableIdentifier.table(any: C.self)
                let aValue = try conn.decode(aType, from: row, table: identifierA)
                let bValue = try conn.decode(bType, from: row, table: identifierB)
                let cValue = conn.decodeOptional(cType, from: row, table: identifierC)
                try handler(aValue, bValue, cValue)
            }
        }
    }
}

/// Types conforming to this protocol can be used to build SQL queries.
extension SQLConnection {
    /// Decodes a `Decodable` type from this connection's output.
    /// If a table is specified, values should come only from columns in that table.
    public func decodeOptional<D>(_ type: Optional<D>.Type, from row: Output, table: Query.Select.TableIdentifier?) -> D?
        where D: Decodable {
            do {
                return try self.decode(D.self, from: row, table: table)
            } catch {
                return nil
            }
    }
}
