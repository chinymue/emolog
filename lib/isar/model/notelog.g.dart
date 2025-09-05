// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notelog.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNoteLogCollection on Isar {
  IsarCollection<NoteLog> get noteLogs => this.collection();
}

const NoteLogSchema = CollectionSchema(
  name: r'NoteLog',
  id: 1643800332374341291,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'isFavor': PropertySchema(
      id: 1,
      name: r'isFavor',
      type: IsarType.bool,
    ),
    r'labelMood': PropertySchema(
      id: 2,
      name: r'labelMood',
      type: IsarType.string,
    ),
    r'lastUpdated': PropertySchema(
      id: 3,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'moodPoint': PropertySchema(
      id: 4,
      name: r'moodPoint',
      type: IsarType.double,
    ),
    r'note': PropertySchema(
      id: 5,
      name: r'note',
      type: IsarType.string,
    )
  },
  estimateSize: _noteLogEstimateSize,
  serialize: _noteLogSerialize,
  deserialize: _noteLogDeserialize,
  deserializeProp: _noteLogDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'user': LinkSchema(
      id: 7564208773626486160,
      name: r'user',
      target: r'User',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _noteLogGetId,
  getLinks: _noteLogGetLinks,
  attach: _noteLogAttach,
  version: '3.1.0+1',
);

int _noteLogEstimateSize(
  NoteLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.labelMood;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _noteLogSerialize(
  NoteLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeBool(offsets[1], object.isFavor);
  writer.writeString(offsets[2], object.labelMood);
  writer.writeDateTime(offsets[3], object.lastUpdated);
  writer.writeDouble(offsets[4], object.moodPoint);
  writer.writeString(offsets[5], object.note);
}

NoteLog _noteLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NoteLog();
  object.date = reader.readDateTime(offsets[0]);
  object.id = id;
  object.isFavor = reader.readBool(offsets[1]);
  object.labelMood = reader.readStringOrNull(offsets[2]);
  object.lastUpdated = reader.readDateTime(offsets[3]);
  object.moodPoint = reader.readDoubleOrNull(offsets[4]);
  object.note = reader.readStringOrNull(offsets[5]);
  return object;
}

P _noteLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _noteLogGetId(NoteLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _noteLogGetLinks(NoteLog object) {
  return [object.user];
}

void _noteLogAttach(IsarCollection<dynamic> col, Id id, NoteLog object) {
  object.id = id;
  object.user.attach(col, col.isar.collection<User>(), r'user', id);
}

extension NoteLogQueryWhereSort on QueryBuilder<NoteLog, NoteLog, QWhere> {
  QueryBuilder<NoteLog, NoteLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NoteLogQueryWhere on QueryBuilder<NoteLog, NoteLog, QWhereClause> {
  QueryBuilder<NoteLog, NoteLog, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<NoteLog, NoteLog, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NoteLogQueryFilter
    on QueryBuilder<NoteLog, NoteLog, QFilterCondition> {
  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> isFavorEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFavor',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> labelMoodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'labelMood',
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> labelMoodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'labelMood',
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> labelMoodEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'labelMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> labelMoodGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'labelMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> labelMoodLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'labelMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> labelMoodBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'labelMood',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> labelMoodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'labelMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> labelMoodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'labelMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> labelMoodContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'labelMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> labelMoodMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'labelMood',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> labelMoodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'labelMood',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> labelMoodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'labelMood',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> lastUpdatedEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> lastUpdatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> lastUpdatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> lastUpdatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> moodPointIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'moodPoint',
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> moodPointIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'moodPoint',
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> moodPointEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moodPoint',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> moodPointGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moodPoint',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> moodPointLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moodPoint',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> moodPointBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moodPoint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> noteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> noteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }
}

extension NoteLogQueryObject
    on QueryBuilder<NoteLog, NoteLog, QFilterCondition> {}

extension NoteLogQueryLinks
    on QueryBuilder<NoteLog, NoteLog, QFilterCondition> {
  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> user(
      FilterQuery<User> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'user');
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterFilterCondition> userIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'user', 0, true, 0, true);
    });
  }
}

extension NoteLogQuerySortBy on QueryBuilder<NoteLog, NoteLog, QSortBy> {
  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> sortByIsFavor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavor', Sort.asc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> sortByIsFavorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavor', Sort.desc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> sortByLabelMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'labelMood', Sort.asc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> sortByLabelMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'labelMood', Sort.desc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> sortByMoodPoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodPoint', Sort.asc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> sortByMoodPointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodPoint', Sort.desc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }
}

extension NoteLogQuerySortThenBy
    on QueryBuilder<NoteLog, NoteLog, QSortThenBy> {
  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> thenByIsFavor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavor', Sort.asc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> thenByIsFavorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavor', Sort.desc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> thenByLabelMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'labelMood', Sort.asc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> thenByLabelMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'labelMood', Sort.desc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> thenByMoodPoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodPoint', Sort.asc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> thenByMoodPointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodPoint', Sort.desc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }
}

extension NoteLogQueryWhereDistinct
    on QueryBuilder<NoteLog, NoteLog, QDistinct> {
  QueryBuilder<NoteLog, NoteLog, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<NoteLog, NoteLog, QDistinct> distinctByIsFavor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavor');
    });
  }

  QueryBuilder<NoteLog, NoteLog, QDistinct> distinctByLabelMood(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'labelMood', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NoteLog, NoteLog, QDistinct> distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<NoteLog, NoteLog, QDistinct> distinctByMoodPoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moodPoint');
    });
  }

  QueryBuilder<NoteLog, NoteLog, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }
}

extension NoteLogQueryProperty
    on QueryBuilder<NoteLog, NoteLog, QQueryProperty> {
  QueryBuilder<NoteLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NoteLog, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<NoteLog, bool, QQueryOperations> isFavorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavor');
    });
  }

  QueryBuilder<NoteLog, String?, QQueryOperations> labelMoodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'labelMood');
    });
  }

  QueryBuilder<NoteLog, DateTime, QQueryOperations> lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<NoteLog, double?, QQueryOperations> moodPointProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moodPoint');
    });
  }

  QueryBuilder<NoteLog, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }
}
