// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relax.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRelaxCollection on Isar {
  IsarCollection<Relax> get relaxs => this.collection();
}

const RelaxSchema = CollectionSchema(
  name: r'Relax',
  id: 4115860736320050041,
  properties: {
    r'durationMiliseconds': PropertySchema(
      id: 0,
      name: r'durationMiliseconds',
      type: IsarType.long,
    ),
    r'endTime': PropertySchema(
      id: 1,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'note': PropertySchema(
      id: 2,
      name: r'note',
      type: IsarType.string,
    ),
    r'relaxId': PropertySchema(
      id: 3,
      name: r'relaxId',
      type: IsarType.string,
    ),
    r'startTime': PropertySchema(
      id: 4,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'userUid': PropertySchema(
      id: 5,
      name: r'userUid',
      type: IsarType.string,
    )
  },
  estimateSize: _relaxEstimateSize,
  serialize: _relaxSerialize,
  deserialize: _relaxDeserialize,
  deserializeProp: _relaxDeserializeProp,
  idName: r'id',
  indexes: {
    r'relaxId': IndexSchema(
      id: -8573900492757861376,
      name: r'relaxId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'relaxId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'userUid': IndexSchema(
      id: 7924673654387171457,
      name: r'userUid',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userUid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _relaxGetId,
  getLinks: _relaxGetLinks,
  attach: _relaxAttach,
  version: '3.1.0+1',
);

int _relaxEstimateSize(
  Relax object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.relaxId.length * 3;
  bytesCount += 3 + object.userUid.length * 3;
  return bytesCount;
}

void _relaxSerialize(
  Relax object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.durationMiliseconds);
  writer.writeDateTime(offsets[1], object.endTime);
  writer.writeString(offsets[2], object.note);
  writer.writeString(offsets[3], object.relaxId);
  writer.writeDateTime(offsets[4], object.startTime);
  writer.writeString(offsets[5], object.userUid);
}

Relax _relaxDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Relax();
  object.durationMiliseconds = reader.readLong(offsets[0]);
  object.endTime = reader.readDateTime(offsets[1]);
  object.id = id;
  object.note = reader.readStringOrNull(offsets[2]);
  object.relaxId = reader.readString(offsets[3]);
  object.startTime = reader.readDateTime(offsets[4]);
  object.userUid = reader.readString(offsets[5]);
  return object;
}

P _relaxDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _relaxGetId(Relax object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _relaxGetLinks(Relax object) {
  return [];
}

void _relaxAttach(IsarCollection<dynamic> col, Id id, Relax object) {
  object.id = id;
}

extension RelaxByIndex on IsarCollection<Relax> {
  Future<Relax?> getByRelaxId(String relaxId) {
    return getByIndex(r'relaxId', [relaxId]);
  }

  Relax? getByRelaxIdSync(String relaxId) {
    return getByIndexSync(r'relaxId', [relaxId]);
  }

  Future<bool> deleteByRelaxId(String relaxId) {
    return deleteByIndex(r'relaxId', [relaxId]);
  }

  bool deleteByRelaxIdSync(String relaxId) {
    return deleteByIndexSync(r'relaxId', [relaxId]);
  }

  Future<List<Relax?>> getAllByRelaxId(List<String> relaxIdValues) {
    final values = relaxIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'relaxId', values);
  }

  List<Relax?> getAllByRelaxIdSync(List<String> relaxIdValues) {
    final values = relaxIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'relaxId', values);
  }

  Future<int> deleteAllByRelaxId(List<String> relaxIdValues) {
    final values = relaxIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'relaxId', values);
  }

  int deleteAllByRelaxIdSync(List<String> relaxIdValues) {
    final values = relaxIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'relaxId', values);
  }

  Future<Id> putByRelaxId(Relax object) {
    return putByIndex(r'relaxId', object);
  }

  Id putByRelaxIdSync(Relax object, {bool saveLinks = true}) {
    return putByIndexSync(r'relaxId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRelaxId(List<Relax> objects) {
    return putAllByIndex(r'relaxId', objects);
  }

  List<Id> putAllByRelaxIdSync(List<Relax> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'relaxId', objects, saveLinks: saveLinks);
  }
}

extension RelaxQueryWhereSort on QueryBuilder<Relax, Relax, QWhere> {
  QueryBuilder<Relax, Relax, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RelaxQueryWhere on QueryBuilder<Relax, Relax, QWhereClause> {
  QueryBuilder<Relax, Relax, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Relax, Relax, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Relax, Relax, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Relax, Relax, QAfterWhereClause> idBetween(
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

  QueryBuilder<Relax, Relax, QAfterWhereClause> relaxIdEqualTo(String relaxId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'relaxId',
        value: [relaxId],
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterWhereClause> relaxIdNotEqualTo(
      String relaxId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'relaxId',
              lower: [],
              upper: [relaxId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'relaxId',
              lower: [relaxId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'relaxId',
              lower: [relaxId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'relaxId',
              lower: [],
              upper: [relaxId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Relax, Relax, QAfterWhereClause> userUidEqualTo(String userUid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userUid',
        value: [userUid],
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterWhereClause> userUidNotEqualTo(
      String userUid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userUid',
              lower: [],
              upper: [userUid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userUid',
              lower: [userUid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userUid',
              lower: [userUid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userUid',
              lower: [],
              upper: [userUid],
              includeUpper: false,
            ));
      }
    });
  }
}

extension RelaxQueryFilter on QueryBuilder<Relax, Relax, QFilterCondition> {
  QueryBuilder<Relax, Relax, QAfterFilterCondition> durationMilisecondsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationMiliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition>
      durationMilisecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationMiliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> durationMilisecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationMiliseconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> durationMilisecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationMiliseconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> endTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> endTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> endTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> endTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Relax, Relax, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Relax, Relax, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Relax, Relax, QAfterFilterCondition> noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> noteEqualTo(
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

  QueryBuilder<Relax, Relax, QAfterFilterCondition> noteGreaterThan(
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

  QueryBuilder<Relax, Relax, QAfterFilterCondition> noteLessThan(
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

  QueryBuilder<Relax, Relax, QAfterFilterCondition> noteBetween(
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

  QueryBuilder<Relax, Relax, QAfterFilterCondition> noteStartsWith(
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

  QueryBuilder<Relax, Relax, QAfterFilterCondition> noteEndsWith(
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

  QueryBuilder<Relax, Relax, QAfterFilterCondition> noteContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> noteMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> relaxIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relaxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> relaxIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relaxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> relaxIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relaxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> relaxIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relaxId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> relaxIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relaxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> relaxIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relaxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> relaxIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relaxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> relaxIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relaxId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> relaxIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relaxId',
        value: '',
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> relaxIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relaxId',
        value: '',
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> startTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> startTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> startTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> startTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> userUidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> userUidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> userUidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> userUidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userUid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> userUidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> userUidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> userUidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> userUidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userUid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> userUidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userUid',
        value: '',
      ));
    });
  }

  QueryBuilder<Relax, Relax, QAfterFilterCondition> userUidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userUid',
        value: '',
      ));
    });
  }
}

extension RelaxQueryObject on QueryBuilder<Relax, Relax, QFilterCondition> {}

extension RelaxQueryLinks on QueryBuilder<Relax, Relax, QFilterCondition> {}

extension RelaxQuerySortBy on QueryBuilder<Relax, Relax, QSortBy> {
  QueryBuilder<Relax, Relax, QAfterSortBy> sortByDurationMiliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMiliseconds', Sort.asc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> sortByDurationMilisecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMiliseconds', Sort.desc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> sortByRelaxId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relaxId', Sort.asc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> sortByRelaxIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relaxId', Sort.desc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> sortByUserUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userUid', Sort.asc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> sortByUserUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userUid', Sort.desc);
    });
  }
}

extension RelaxQuerySortThenBy on QueryBuilder<Relax, Relax, QSortThenBy> {
  QueryBuilder<Relax, Relax, QAfterSortBy> thenByDurationMiliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMiliseconds', Sort.asc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> thenByDurationMilisecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMiliseconds', Sort.desc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> thenByRelaxId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relaxId', Sort.asc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> thenByRelaxIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relaxId', Sort.desc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> thenByUserUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userUid', Sort.asc);
    });
  }

  QueryBuilder<Relax, Relax, QAfterSortBy> thenByUserUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userUid', Sort.desc);
    });
  }
}

extension RelaxQueryWhereDistinct on QueryBuilder<Relax, Relax, QDistinct> {
  QueryBuilder<Relax, Relax, QDistinct> distinctByDurationMiliseconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationMiliseconds');
    });
  }

  QueryBuilder<Relax, Relax, QDistinct> distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<Relax, Relax, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Relax, Relax, QDistinct> distinctByRelaxId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relaxId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Relax, Relax, QDistinct> distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<Relax, Relax, QDistinct> distinctByUserUid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userUid', caseSensitive: caseSensitive);
    });
  }
}

extension RelaxQueryProperty on QueryBuilder<Relax, Relax, QQueryProperty> {
  QueryBuilder<Relax, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Relax, int, QQueryOperations> durationMilisecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationMiliseconds');
    });
  }

  QueryBuilder<Relax, DateTime, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<Relax, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<Relax, String, QQueryOperations> relaxIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relaxId');
    });
  }

  QueryBuilder<Relax, DateTime, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<Relax, String, QQueryOperations> userUidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userUid');
    });
  }
}
