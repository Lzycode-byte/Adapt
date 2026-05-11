// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_snapshot.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailySnapshotCollection on Isar {
  IsarCollection<DailySnapshot> get dailySnapshots => this.collection();
}

const DailySnapshotSchema = CollectionSchema(
  name: r'DailySnapshot',
  id: 3585978982778303020,
  properties: {
    r'completionStatus': PropertySchema(
      id: 0,
      name: r'completionStatus',
      type: IsarType.boolList,
    ),
    r'date': PropertySchema(id: 1, name: r'date', type: IsarType.dateTime),
    r'habitIds': PropertySchema(
      id: 2,
      name: r'habitIds',
      type: IsarType.longList,
    ),
    r'habitNames': PropertySchema(
      id: 3,
      name: r'habitNames',
      type: IsarType.stringList,
    ),
  },

  estimateSize: _dailySnapshotEstimateSize,
  serialize: _dailySnapshotSerialize,
  deserialize: _dailySnapshotDeserialize,
  deserializeProp: _dailySnapshotDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _dailySnapshotGetId,
  getLinks: _dailySnapshotGetLinks,
  attach: _dailySnapshotAttach,
  version: '3.3.2',
);

int _dailySnapshotEstimateSize(
  DailySnapshot object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.completionStatus.length;
  bytesCount += 3 + object.habitIds.length * 8;
  bytesCount += 3 + object.habitNames.length * 3;
  {
    for (var i = 0; i < object.habitNames.length; i++) {
      final value = object.habitNames[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _dailySnapshotSerialize(
  DailySnapshot object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBoolList(offsets[0], object.completionStatus);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeLongList(offsets[2], object.habitIds);
  writer.writeStringList(offsets[3], object.habitNames);
}

DailySnapshot _dailySnapshotDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailySnapshot();
  object.completionStatus = reader.readBoolList(offsets[0]) ?? [];
  object.date = reader.readDateTime(offsets[1]);
  object.habitIds = reader.readLongList(offsets[2]) ?? [];
  object.habitNames = reader.readStringList(offsets[3]) ?? [];
  object.id = id;
  return object;
}

P _dailySnapshotDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolList(offset) ?? []) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLongList(offset) ?? []) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailySnapshotGetId(DailySnapshot object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailySnapshotGetLinks(DailySnapshot object) {
  return [];
}

void _dailySnapshotAttach(
  IsarCollection<dynamic> col,
  Id id,
  DailySnapshot object,
) {
  object.id = id;
}

extension DailySnapshotQueryWhereSort
    on QueryBuilder<DailySnapshot, DailySnapshot, QWhere> {
  QueryBuilder<DailySnapshot, DailySnapshot, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DailySnapshotQueryWhere
    on QueryBuilder<DailySnapshot, DailySnapshot, QWhereClause> {
  QueryBuilder<DailySnapshot, DailySnapshot, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DailySnapshotQueryFilter
    on QueryBuilder<DailySnapshot, DailySnapshot, QFilterCondition> {
  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  completionStatusElementEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completionStatus', value: value),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  completionStatusLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'completionStatus', length, true, length, true);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  completionStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'completionStatus', 0, true, 0, true);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  completionStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'completionStatus', 0, false, 999999, true);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  completionStatusLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'completionStatus', 0, true, length, include);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  completionStatusLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completionStatus',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  completionStatusLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completionStatus',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition> dateEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: value),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  dateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  dateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'date',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'habitIds', value: value),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitIdsElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'habitIds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitIdsElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'habitIds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'habitIds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'habitIds', length, true, length, true);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'habitIds', 0, true, 0, true);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'habitIds', 0, false, 999999, true);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitIdsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'habitIds', 0, true, length, include);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitIdsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'habitIds', length, include, 999999, true);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'habitIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitNamesElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'habitNames',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitNamesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'habitNames',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitNamesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'habitNames',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitNamesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'habitNames',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitNamesElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'habitNames',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitNamesElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'habitNames',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitNamesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'habitNames',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitNamesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'habitNames',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitNamesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'habitNames', value: ''),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitNamesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'habitNames', value: ''),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitNamesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'habitNames', length, true, length, true);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitNamesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'habitNames', 0, true, 0, true);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitNamesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'habitNames', 0, false, 999999, true);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitNamesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'habitNames', 0, true, length, include);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitNamesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'habitNames', length, include, 999999, true);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  habitNamesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'habitNames',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DailySnapshotQueryObject
    on QueryBuilder<DailySnapshot, DailySnapshot, QFilterCondition> {}

extension DailySnapshotQueryLinks
    on QueryBuilder<DailySnapshot, DailySnapshot, QFilterCondition> {}

extension DailySnapshotQuerySortBy
    on QueryBuilder<DailySnapshot, DailySnapshot, QSortBy> {
  QueryBuilder<DailySnapshot, DailySnapshot, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }
}

extension DailySnapshotQuerySortThenBy
    on QueryBuilder<DailySnapshot, DailySnapshot, QSortThenBy> {
  QueryBuilder<DailySnapshot, DailySnapshot, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension DailySnapshotQueryWhereDistinct
    on QueryBuilder<DailySnapshot, DailySnapshot, QDistinct> {
  QueryBuilder<DailySnapshot, DailySnapshot, QDistinct>
  distinctByCompletionStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completionStatus');
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QDistinct> distinctByHabitIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'habitIds');
    });
  }

  QueryBuilder<DailySnapshot, DailySnapshot, QDistinct> distinctByHabitNames() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'habitNames');
    });
  }
}

extension DailySnapshotQueryProperty
    on QueryBuilder<DailySnapshot, DailySnapshot, QQueryProperty> {
  QueryBuilder<DailySnapshot, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailySnapshot, List<bool>, QQueryOperations>
  completionStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completionStatus');
    });
  }

  QueryBuilder<DailySnapshot, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailySnapshot, List<int>, QQueryOperations> habitIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habitIds');
    });
  }

  QueryBuilder<DailySnapshot, List<String>, QQueryOperations>
  habitNamesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habitNames');
    });
  }
}
