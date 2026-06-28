// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MedicationsTableTable extends MedicationsTable
    with TableInfo<$MedicationsTableTable, MedicationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dosageValueMeta = const VerificationMeta(
    'dosageValue',
  );
  @override
  late final GeneratedColumn<double> dosageValue = GeneratedColumn<double>(
    'dosage_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dosageUnitMeta = const VerificationMeta(
    'dosageUnit',
  );
  @override
  late final GeneratedColumn<String> dosageUnit = GeneratedColumn<String>(
    'dosage_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyPerDayMeta = const VerificationMeta(
    'frequencyPerDay',
  );
  @override
  late final GeneratedColumn<int> frequencyPerDay = GeneratedColumn<int>(
    'frequency_per_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intervalHoursMeta = const VerificationMeta(
    'intervalHours',
  );
  @override
  late final GeneratedColumn<double> intervalHours = GeneratedColumn<double>(
    'interval_hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timesMeta = const VerificationMeta('times');
  @override
  late final GeneratedColumn<String> times = GeneratedColumn<String>(
    'times',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remainingPillsMeta = const VerificationMeta(
    'remainingPills',
  );
  @override
  late final GeneratedColumn<int> remainingPills = GeneratedColumn<int>(
    'remaining_pills',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    dosageValue,
    dosageUnit,
    frequencyPerDay,
    intervalHours,
    times,
    color,
    icon,
    isArchived,
    isCompleted,
    notes,
    startDate,
    endDate,
    remainingPills,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('dosage_value')) {
      context.handle(
        _dosageValueMeta,
        dosageValue.isAcceptableOrUnknown(
          data['dosage_value']!,
          _dosageValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dosageValueMeta);
    }
    if (data.containsKey('dosage_unit')) {
      context.handle(
        _dosageUnitMeta,
        dosageUnit.isAcceptableOrUnknown(data['dosage_unit']!, _dosageUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_dosageUnitMeta);
    }
    if (data.containsKey('frequency_per_day')) {
      context.handle(
        _frequencyPerDayMeta,
        frequencyPerDay.isAcceptableOrUnknown(
          data['frequency_per_day']!,
          _frequencyPerDayMeta,
        ),
      );
    }
    if (data.containsKey('interval_hours')) {
      context.handle(
        _intervalHoursMeta,
        intervalHours.isAcceptableOrUnknown(
          data['interval_hours']!,
          _intervalHoursMeta,
        ),
      );
    }
    if (data.containsKey('times')) {
      context.handle(
        _timesMeta,
        times.isAcceptableOrUnknown(data['times']!, _timesMeta),
      );
    } else if (isInserting) {
      context.missing(_timesMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('remaining_pills')) {
      context.handle(
        _remainingPillsMeta,
        remainingPills.isAcceptableOrUnknown(
          data['remaining_pills']!,
          _remainingPillsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      dosageValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}dosage_value'],
      )!,
      dosageUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage_unit'],
      )!,
      frequencyPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frequency_per_day'],
      ),
      intervalHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}interval_hours'],
      ),
      times: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}times'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      ),
      remainingPills: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remaining_pills'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MedicationsTableTable createAlias(String alias) {
    return $MedicationsTableTable(attachedDatabase, alias);
  }
}

class MedicationsTableData extends DataClass
    implements Insertable<MedicationsTableData> {
  final int id;
  final String name;
  final String? description;
  final double dosageValue;
  final String dosageUnit;
  final int? frequencyPerDay;
  final double? intervalHours;
  final String times;
  final int color;
  final String? icon;
  final bool isArchived;
  final bool isCompleted;
  final String? notes;
  final String startDate;
  final String? endDate;
  final int? remainingPills;
  final String createdAt;
  final String updatedAt;
  const MedicationsTableData({
    required this.id,
    required this.name,
    this.description,
    required this.dosageValue,
    required this.dosageUnit,
    this.frequencyPerDay,
    this.intervalHours,
    required this.times,
    required this.color,
    this.icon,
    required this.isArchived,
    required this.isCompleted,
    this.notes,
    required this.startDate,
    this.endDate,
    this.remainingPills,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['dosage_value'] = Variable<double>(dosageValue);
    map['dosage_unit'] = Variable<String>(dosageUnit);
    if (!nullToAbsent || frequencyPerDay != null) {
      map['frequency_per_day'] = Variable<int>(frequencyPerDay);
    }
    if (!nullToAbsent || intervalHours != null) {
      map['interval_hours'] = Variable<double>(intervalHours);
    }
    map['times'] = Variable<String>(times);
    map['color'] = Variable<int>(color);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['start_date'] = Variable<String>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    if (!nullToAbsent || remainingPills != null) {
      map['remaining_pills'] = Variable<int>(remainingPills);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  MedicationsTableCompanion toCompanion(bool nullToAbsent) {
    return MedicationsTableCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dosageValue: Value(dosageValue),
      dosageUnit: Value(dosageUnit),
      frequencyPerDay: frequencyPerDay == null && nullToAbsent
          ? const Value.absent()
          : Value(frequencyPerDay),
      intervalHours: intervalHours == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalHours),
      times: Value(times),
      color: Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      isArchived: Value(isArchived),
      isCompleted: Value(isCompleted),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      remainingPills: remainingPills == null && nullToAbsent
          ? const Value.absent()
          : Value(remainingPills),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MedicationsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationsTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      dosageValue: serializer.fromJson<double>(json['dosageValue']),
      dosageUnit: serializer.fromJson<String>(json['dosageUnit']),
      frequencyPerDay: serializer.fromJson<int?>(json['frequencyPerDay']),
      intervalHours: serializer.fromJson<double?>(json['intervalHours']),
      times: serializer.fromJson<String>(json['times']),
      color: serializer.fromJson<int>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      notes: serializer.fromJson<String?>(json['notes']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      remainingPills: serializer.fromJson<int?>(json['remainingPills']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'dosageValue': serializer.toJson<double>(dosageValue),
      'dosageUnit': serializer.toJson<String>(dosageUnit),
      'frequencyPerDay': serializer.toJson<int?>(frequencyPerDay),
      'intervalHours': serializer.toJson<double?>(intervalHours),
      'times': serializer.toJson<String>(times),
      'color': serializer.toJson<int>(color),
      'icon': serializer.toJson<String?>(icon),
      'isArchived': serializer.toJson<bool>(isArchived),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'notes': serializer.toJson<String?>(notes),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'remainingPills': serializer.toJson<int?>(remainingPills),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  MedicationsTableData copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    double? dosageValue,
    String? dosageUnit,
    Value<int?> frequencyPerDay = const Value.absent(),
    Value<double?> intervalHours = const Value.absent(),
    String? times,
    int? color,
    Value<String?> icon = const Value.absent(),
    bool? isArchived,
    bool? isCompleted,
    Value<String?> notes = const Value.absent(),
    String? startDate,
    Value<String?> endDate = const Value.absent(),
    Value<int?> remainingPills = const Value.absent(),
    String? createdAt,
    String? updatedAt,
  }) => MedicationsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    dosageValue: dosageValue ?? this.dosageValue,
    dosageUnit: dosageUnit ?? this.dosageUnit,
    frequencyPerDay: frequencyPerDay.present
        ? frequencyPerDay.value
        : this.frequencyPerDay,
    intervalHours: intervalHours.present
        ? intervalHours.value
        : this.intervalHours,
    times: times ?? this.times,
    color: color ?? this.color,
    icon: icon.present ? icon.value : this.icon,
    isArchived: isArchived ?? this.isArchived,
    isCompleted: isCompleted ?? this.isCompleted,
    notes: notes.present ? notes.value : this.notes,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    remainingPills: remainingPills.present
        ? remainingPills.value
        : this.remainingPills,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MedicationsTableData copyWithCompanion(MedicationsTableCompanion data) {
    return MedicationsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      dosageValue: data.dosageValue.present
          ? data.dosageValue.value
          : this.dosageValue,
      dosageUnit: data.dosageUnit.present
          ? data.dosageUnit.value
          : this.dosageUnit,
      frequencyPerDay: data.frequencyPerDay.present
          ? data.frequencyPerDay.value
          : this.frequencyPerDay,
      intervalHours: data.intervalHours.present
          ? data.intervalHours.value
          : this.intervalHours,
      times: data.times.present ? data.times.value : this.times,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      notes: data.notes.present ? data.notes.value : this.notes,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      remainingPills: data.remainingPills.present
          ? data.remainingPills.value
          : this.remainingPills,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('dosageValue: $dosageValue, ')
          ..write('dosageUnit: $dosageUnit, ')
          ..write('frequencyPerDay: $frequencyPerDay, ')
          ..write('intervalHours: $intervalHours, ')
          ..write('times: $times, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('isArchived: $isArchived, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('notes: $notes, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('remainingPills: $remainingPills, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    dosageValue,
    dosageUnit,
    frequencyPerDay,
    intervalHours,
    times,
    color,
    icon,
    isArchived,
    isCompleted,
    notes,
    startDate,
    endDate,
    remainingPills,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.dosageValue == this.dosageValue &&
          other.dosageUnit == this.dosageUnit &&
          other.frequencyPerDay == this.frequencyPerDay &&
          other.intervalHours == this.intervalHours &&
          other.times == this.times &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.isArchived == this.isArchived &&
          other.isCompleted == this.isCompleted &&
          other.notes == this.notes &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.remainingPills == this.remainingPills &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MedicationsTableCompanion extends UpdateCompanion<MedicationsTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<double> dosageValue;
  final Value<String> dosageUnit;
  final Value<int?> frequencyPerDay;
  final Value<double?> intervalHours;
  final Value<String> times;
  final Value<int> color;
  final Value<String?> icon;
  final Value<bool> isArchived;
  final Value<bool> isCompleted;
  final Value<String?> notes;
  final Value<String> startDate;
  final Value<String?> endDate;
  final Value<int?> remainingPills;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const MedicationsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.dosageValue = const Value.absent(),
    this.dosageUnit = const Value.absent(),
    this.frequencyPerDay = const Value.absent(),
    this.intervalHours = const Value.absent(),
    this.times = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.notes = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.remainingPills = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MedicationsTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required double dosageValue,
    required String dosageUnit,
    this.frequencyPerDay = const Value.absent(),
    this.intervalHours = const Value.absent(),
    required String times,
    required int color,
    this.icon = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.notes = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.remainingPills = const Value.absent(),
    required String createdAt,
    required String updatedAt,
  }) : name = Value(name),
       dosageValue = Value(dosageValue),
       dosageUnit = Value(dosageUnit),
       times = Value(times),
       color = Value(color),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MedicationsTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? dosageValue,
    Expression<String>? dosageUnit,
    Expression<int>? frequencyPerDay,
    Expression<double>? intervalHours,
    Expression<String>? times,
    Expression<int>? color,
    Expression<String>? icon,
    Expression<bool>? isArchived,
    Expression<bool>? isCompleted,
    Expression<String>? notes,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<int>? remainingPills,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (dosageValue != null) 'dosage_value': dosageValue,
      if (dosageUnit != null) 'dosage_unit': dosageUnit,
      if (frequencyPerDay != null) 'frequency_per_day': frequencyPerDay,
      if (intervalHours != null) 'interval_hours': intervalHours,
      if (times != null) 'times': times,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (isArchived != null) 'is_archived': isArchived,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (notes != null) 'notes': notes,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (remainingPills != null) 'remaining_pills': remainingPills,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MedicationsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<double>? dosageValue,
    Value<String>? dosageUnit,
    Value<int?>? frequencyPerDay,
    Value<double?>? intervalHours,
    Value<String>? times,
    Value<int>? color,
    Value<String?>? icon,
    Value<bool>? isArchived,
    Value<bool>? isCompleted,
    Value<String?>? notes,
    Value<String>? startDate,
    Value<String?>? endDate,
    Value<int?>? remainingPills,
    Value<String>? createdAt,
    Value<String>? updatedAt,
  }) {
    return MedicationsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dosageValue: dosageValue ?? this.dosageValue,
      dosageUnit: dosageUnit ?? this.dosageUnit,
      frequencyPerDay: frequencyPerDay ?? this.frequencyPerDay,
      intervalHours: intervalHours ?? this.intervalHours,
      times: times ?? this.times,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isArchived: isArchived ?? this.isArchived,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      remainingPills: remainingPills ?? this.remainingPills,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dosageValue.present) {
      map['dosage_value'] = Variable<double>(dosageValue.value);
    }
    if (dosageUnit.present) {
      map['dosage_unit'] = Variable<String>(dosageUnit.value);
    }
    if (frequencyPerDay.present) {
      map['frequency_per_day'] = Variable<int>(frequencyPerDay.value);
    }
    if (intervalHours.present) {
      map['interval_hours'] = Variable<double>(intervalHours.value);
    }
    if (times.present) {
      map['times'] = Variable<String>(times.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (remainingPills.present) {
      map['remaining_pills'] = Variable<int>(remainingPills.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('dosageValue: $dosageValue, ')
          ..write('dosageUnit: $dosageUnit, ')
          ..write('frequencyPerDay: $frequencyPerDay, ')
          ..write('intervalHours: $intervalHours, ')
          ..write('times: $times, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('isArchived: $isArchived, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('notes: $notes, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('remainingPills: $remainingPills, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MedicationLogsTableTable extends MedicationLogsTable
    with TableInfo<$MedicationLogsTableTable, MedicationLogsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationLogsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<int> medicationId = GeneratedColumn<int>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications_table (id)',
    ),
  );
  static const VerificationMeta _scheduledTimeMeta = const VerificationMeta(
    'scheduledTime',
  );
  @override
  late final GeneratedColumn<String> scheduledTime = GeneratedColumn<String>(
    'scheduled_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _takenTimeMeta = const VerificationMeta(
    'takenTime',
  );
  @override
  late final GeneratedColumn<String> takenTime = GeneratedColumn<String>(
    'taken_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dosageTakenMeta = const VerificationMeta(
    'dosageTaken',
  );
  @override
  late final GeneratedColumn<double> dosageTaken = GeneratedColumn<double>(
    'dosage_taken',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    scheduledTime,
    takenTime,
    status,
    dosageTaken,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medication_logs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationLogsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('scheduled_time')) {
      context.handle(
        _scheduledTimeMeta,
        scheduledTime.isAcceptableOrUnknown(
          data['scheduled_time']!,
          _scheduledTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledTimeMeta);
    }
    if (data.containsKey('taken_time')) {
      context.handle(
        _takenTimeMeta,
        takenTime.isAcceptableOrUnknown(data['taken_time']!, _takenTimeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('dosage_taken')) {
      context.handle(
        _dosageTakenMeta,
        dosageTaken.isAcceptableOrUnknown(
          data['dosage_taken']!,
          _dosageTakenMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicationLogsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationLogsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medication_id'],
      )!,
      scheduledTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_time'],
      )!,
      takenTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}taken_time'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      dosageTaken: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}dosage_taken'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MedicationLogsTableTable createAlias(String alias) {
    return $MedicationLogsTableTable(attachedDatabase, alias);
  }
}

class MedicationLogsTableData extends DataClass
    implements Insertable<MedicationLogsTableData> {
  final int id;
  final int medicationId;
  final String scheduledTime;
  final String? takenTime;
  final String status;
  final double? dosageTaken;
  final String? notes;
  final String createdAt;
  const MedicationLogsTableData({
    required this.id,
    required this.medicationId,
    required this.scheduledTime,
    this.takenTime,
    required this.status,
    this.dosageTaken,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['medication_id'] = Variable<int>(medicationId);
    map['scheduled_time'] = Variable<String>(scheduledTime);
    if (!nullToAbsent || takenTime != null) {
      map['taken_time'] = Variable<String>(takenTime);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || dosageTaken != null) {
      map['dosage_taken'] = Variable<double>(dosageTaken);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  MedicationLogsTableCompanion toCompanion(bool nullToAbsent) {
    return MedicationLogsTableCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      scheduledTime: Value(scheduledTime),
      takenTime: takenTime == null && nullToAbsent
          ? const Value.absent()
          : Value(takenTime),
      status: Value(status),
      dosageTaken: dosageTaken == null && nullToAbsent
          ? const Value.absent()
          : Value(dosageTaken),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory MedicationLogsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationLogsTableData(
      id: serializer.fromJson<int>(json['id']),
      medicationId: serializer.fromJson<int>(json['medicationId']),
      scheduledTime: serializer.fromJson<String>(json['scheduledTime']),
      takenTime: serializer.fromJson<String?>(json['takenTime']),
      status: serializer.fromJson<String>(json['status']),
      dosageTaken: serializer.fromJson<double?>(json['dosageTaken']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medicationId': serializer.toJson<int>(medicationId),
      'scheduledTime': serializer.toJson<String>(scheduledTime),
      'takenTime': serializer.toJson<String?>(takenTime),
      'status': serializer.toJson<String>(status),
      'dosageTaken': serializer.toJson<double?>(dosageTaken),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  MedicationLogsTableData copyWith({
    int? id,
    int? medicationId,
    String? scheduledTime,
    Value<String?> takenTime = const Value.absent(),
    String? status,
    Value<double?> dosageTaken = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? createdAt,
  }) => MedicationLogsTableData(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    scheduledTime: scheduledTime ?? this.scheduledTime,
    takenTime: takenTime.present ? takenTime.value : this.takenTime,
    status: status ?? this.status,
    dosageTaken: dosageTaken.present ? dosageTaken.value : this.dosageTaken,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  MedicationLogsTableData copyWithCompanion(MedicationLogsTableCompanion data) {
    return MedicationLogsTableData(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      scheduledTime: data.scheduledTime.present
          ? data.scheduledTime.value
          : this.scheduledTime,
      takenTime: data.takenTime.present ? data.takenTime.value : this.takenTime,
      status: data.status.present ? data.status.value : this.status,
      dosageTaken: data.dosageTaken.present
          ? data.dosageTaken.value
          : this.dosageTaken,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationLogsTableData(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('takenTime: $takenTime, ')
          ..write('status: $status, ')
          ..write('dosageTaken: $dosageTaken, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicationId,
    scheduledTime,
    takenTime,
    status,
    dosageTaken,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationLogsTableData &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.scheduledTime == this.scheduledTime &&
          other.takenTime == this.takenTime &&
          other.status == this.status &&
          other.dosageTaken == this.dosageTaken &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class MedicationLogsTableCompanion
    extends UpdateCompanion<MedicationLogsTableData> {
  final Value<int> id;
  final Value<int> medicationId;
  final Value<String> scheduledTime;
  final Value<String?> takenTime;
  final Value<String> status;
  final Value<double?> dosageTaken;
  final Value<String?> notes;
  final Value<String> createdAt;
  const MedicationLogsTableCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    this.takenTime = const Value.absent(),
    this.status = const Value.absent(),
    this.dosageTaken = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MedicationLogsTableCompanion.insert({
    this.id = const Value.absent(),
    required int medicationId,
    required String scheduledTime,
    this.takenTime = const Value.absent(),
    required String status,
    this.dosageTaken = const Value.absent(),
    this.notes = const Value.absent(),
    required String createdAt,
  }) : medicationId = Value(medicationId),
       scheduledTime = Value(scheduledTime),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<MedicationLogsTableData> custom({
    Expression<int>? id,
    Expression<int>? medicationId,
    Expression<String>? scheduledTime,
    Expression<String>? takenTime,
    Expression<String>? status,
    Expression<double>? dosageTaken,
    Expression<String>? notes,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (scheduledTime != null) 'scheduled_time': scheduledTime,
      if (takenTime != null) 'taken_time': takenTime,
      if (status != null) 'status': status,
      if (dosageTaken != null) 'dosage_taken': dosageTaken,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MedicationLogsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? medicationId,
    Value<String>? scheduledTime,
    Value<String?>? takenTime,
    Value<String>? status,
    Value<double?>? dosageTaken,
    Value<String?>? notes,
    Value<String>? createdAt,
  }) {
    return MedicationLogsTableCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      takenTime: takenTime ?? this.takenTime,
      status: status ?? this.status,
      dosageTaken: dosageTaken ?? this.dosageTaken,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<int>(medicationId.value);
    }
    if (scheduledTime.present) {
      map['scheduled_time'] = Variable<String>(scheduledTime.value);
    }
    if (takenTime.present) {
      map['taken_time'] = Variable<String>(takenTime.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (dosageTaken.present) {
      map['dosage_taken'] = Variable<double>(dosageTaken.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('takenTime: $takenTime, ')
          ..write('status: $status, ')
          ..write('dosageTaken: $dosageTaken, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DosageChangesTableTable extends DosageChangesTable
    with TableInfo<$DosageChangesTableTable, DosageChangesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DosageChangesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicationIdMeta = const VerificationMeta(
    'medicationId',
  );
  @override
  late final GeneratedColumn<int> medicationId = GeneratedColumn<int>(
    'medication_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medications_table (id)',
    ),
  );
  static const VerificationMeta _oldValueMeta = const VerificationMeta(
    'oldValue',
  );
  @override
  late final GeneratedColumn<double> oldValue = GeneratedColumn<double>(
    'old_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _oldUnitMeta = const VerificationMeta(
    'oldUnit',
  );
  @override
  late final GeneratedColumn<String> oldUnit = GeneratedColumn<String>(
    'old_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newValueMeta = const VerificationMeta(
    'newValue',
  );
  @override
  late final GeneratedColumn<double> newValue = GeneratedColumn<double>(
    'new_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newUnitMeta = const VerificationMeta(
    'newUnit',
  );
  @override
  late final GeneratedColumn<String> newUnit = GeneratedColumn<String>(
    'new_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _changedAtMeta = const VerificationMeta(
    'changedAt',
  );
  @override
  late final GeneratedColumn<String> changedAt = GeneratedColumn<String>(
    'changed_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicationId,
    oldValue,
    oldUnit,
    newValue,
    newUnit,
    reason,
    changedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dosage_changes_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DosageChangesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medication_id')) {
      context.handle(
        _medicationIdMeta,
        medicationId.isAcceptableOrUnknown(
          data['medication_id']!,
          _medicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_medicationIdMeta);
    }
    if (data.containsKey('old_value')) {
      context.handle(
        _oldValueMeta,
        oldValue.isAcceptableOrUnknown(data['old_value']!, _oldValueMeta),
      );
    } else if (isInserting) {
      context.missing(_oldValueMeta);
    }
    if (data.containsKey('old_unit')) {
      context.handle(
        _oldUnitMeta,
        oldUnit.isAcceptableOrUnknown(data['old_unit']!, _oldUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_oldUnitMeta);
    }
    if (data.containsKey('new_value')) {
      context.handle(
        _newValueMeta,
        newValue.isAcceptableOrUnknown(data['new_value']!, _newValueMeta),
      );
    } else if (isInserting) {
      context.missing(_newValueMeta);
    }
    if (data.containsKey('new_unit')) {
      context.handle(
        _newUnitMeta,
        newUnit.isAcceptableOrUnknown(data['new_unit']!, _newUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_newUnitMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('changed_at')) {
      context.handle(
        _changedAtMeta,
        changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_changedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DosageChangesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DosageChangesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      medicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medication_id'],
      )!,
      oldValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}old_value'],
      )!,
      oldUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}old_unit'],
      )!,
      newValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}new_value'],
      )!,
      newUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}new_unit'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      changedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}changed_at'],
      )!,
    );
  }

  @override
  $DosageChangesTableTable createAlias(String alias) {
    return $DosageChangesTableTable(attachedDatabase, alias);
  }
}

class DosageChangesTableData extends DataClass
    implements Insertable<DosageChangesTableData> {
  final int id;
  final int medicationId;
  final double oldValue;
  final String oldUnit;
  final double newValue;
  final String newUnit;
  final String? reason;
  final String changedAt;
  const DosageChangesTableData({
    required this.id,
    required this.medicationId,
    required this.oldValue,
    required this.oldUnit,
    required this.newValue,
    required this.newUnit,
    this.reason,
    required this.changedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['medication_id'] = Variable<int>(medicationId);
    map['old_value'] = Variable<double>(oldValue);
    map['old_unit'] = Variable<String>(oldUnit);
    map['new_value'] = Variable<double>(newValue);
    map['new_unit'] = Variable<String>(newUnit);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['changed_at'] = Variable<String>(changedAt);
    return map;
  }

  DosageChangesTableCompanion toCompanion(bool nullToAbsent) {
    return DosageChangesTableCompanion(
      id: Value(id),
      medicationId: Value(medicationId),
      oldValue: Value(oldValue),
      oldUnit: Value(oldUnit),
      newValue: Value(newValue),
      newUnit: Value(newUnit),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      changedAt: Value(changedAt),
    );
  }

  factory DosageChangesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DosageChangesTableData(
      id: serializer.fromJson<int>(json['id']),
      medicationId: serializer.fromJson<int>(json['medicationId']),
      oldValue: serializer.fromJson<double>(json['oldValue']),
      oldUnit: serializer.fromJson<String>(json['oldUnit']),
      newValue: serializer.fromJson<double>(json['newValue']),
      newUnit: serializer.fromJson<String>(json['newUnit']),
      reason: serializer.fromJson<String?>(json['reason']),
      changedAt: serializer.fromJson<String>(json['changedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medicationId': serializer.toJson<int>(medicationId),
      'oldValue': serializer.toJson<double>(oldValue),
      'oldUnit': serializer.toJson<String>(oldUnit),
      'newValue': serializer.toJson<double>(newValue),
      'newUnit': serializer.toJson<String>(newUnit),
      'reason': serializer.toJson<String?>(reason),
      'changedAt': serializer.toJson<String>(changedAt),
    };
  }

  DosageChangesTableData copyWith({
    int? id,
    int? medicationId,
    double? oldValue,
    String? oldUnit,
    double? newValue,
    String? newUnit,
    Value<String?> reason = const Value.absent(),
    String? changedAt,
  }) => DosageChangesTableData(
    id: id ?? this.id,
    medicationId: medicationId ?? this.medicationId,
    oldValue: oldValue ?? this.oldValue,
    oldUnit: oldUnit ?? this.oldUnit,
    newValue: newValue ?? this.newValue,
    newUnit: newUnit ?? this.newUnit,
    reason: reason.present ? reason.value : this.reason,
    changedAt: changedAt ?? this.changedAt,
  );
  DosageChangesTableData copyWithCompanion(DosageChangesTableCompanion data) {
    return DosageChangesTableData(
      id: data.id.present ? data.id.value : this.id,
      medicationId: data.medicationId.present
          ? data.medicationId.value
          : this.medicationId,
      oldValue: data.oldValue.present ? data.oldValue.value : this.oldValue,
      oldUnit: data.oldUnit.present ? data.oldUnit.value : this.oldUnit,
      newValue: data.newValue.present ? data.newValue.value : this.newValue,
      newUnit: data.newUnit.present ? data.newUnit.value : this.newUnit,
      reason: data.reason.present ? data.reason.value : this.reason,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DosageChangesTableData(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('oldValue: $oldValue, ')
          ..write('oldUnit: $oldUnit, ')
          ..write('newValue: $newValue, ')
          ..write('newUnit: $newUnit, ')
          ..write('reason: $reason, ')
          ..write('changedAt: $changedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicationId,
    oldValue,
    oldUnit,
    newValue,
    newUnit,
    reason,
    changedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DosageChangesTableData &&
          other.id == this.id &&
          other.medicationId == this.medicationId &&
          other.oldValue == this.oldValue &&
          other.oldUnit == this.oldUnit &&
          other.newValue == this.newValue &&
          other.newUnit == this.newUnit &&
          other.reason == this.reason &&
          other.changedAt == this.changedAt);
}

class DosageChangesTableCompanion
    extends UpdateCompanion<DosageChangesTableData> {
  final Value<int> id;
  final Value<int> medicationId;
  final Value<double> oldValue;
  final Value<String> oldUnit;
  final Value<double> newValue;
  final Value<String> newUnit;
  final Value<String?> reason;
  final Value<String> changedAt;
  const DosageChangesTableCompanion({
    this.id = const Value.absent(),
    this.medicationId = const Value.absent(),
    this.oldValue = const Value.absent(),
    this.oldUnit = const Value.absent(),
    this.newValue = const Value.absent(),
    this.newUnit = const Value.absent(),
    this.reason = const Value.absent(),
    this.changedAt = const Value.absent(),
  });
  DosageChangesTableCompanion.insert({
    this.id = const Value.absent(),
    required int medicationId,
    required double oldValue,
    required String oldUnit,
    required double newValue,
    required String newUnit,
    this.reason = const Value.absent(),
    required String changedAt,
  }) : medicationId = Value(medicationId),
       oldValue = Value(oldValue),
       oldUnit = Value(oldUnit),
       newValue = Value(newValue),
       newUnit = Value(newUnit),
       changedAt = Value(changedAt);
  static Insertable<DosageChangesTableData> custom({
    Expression<int>? id,
    Expression<int>? medicationId,
    Expression<double>? oldValue,
    Expression<String>? oldUnit,
    Expression<double>? newValue,
    Expression<String>? newUnit,
    Expression<String>? reason,
    Expression<String>? changedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicationId != null) 'medication_id': medicationId,
      if (oldValue != null) 'old_value': oldValue,
      if (oldUnit != null) 'old_unit': oldUnit,
      if (newValue != null) 'new_value': newValue,
      if (newUnit != null) 'new_unit': newUnit,
      if (reason != null) 'reason': reason,
      if (changedAt != null) 'changed_at': changedAt,
    });
  }

  DosageChangesTableCompanion copyWith({
    Value<int>? id,
    Value<int>? medicationId,
    Value<double>? oldValue,
    Value<String>? oldUnit,
    Value<double>? newValue,
    Value<String>? newUnit,
    Value<String?>? reason,
    Value<String>? changedAt,
  }) {
    return DosageChangesTableCompanion(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      oldValue: oldValue ?? this.oldValue,
      oldUnit: oldUnit ?? this.oldUnit,
      newValue: newValue ?? this.newValue,
      newUnit: newUnit ?? this.newUnit,
      reason: reason ?? this.reason,
      changedAt: changedAt ?? this.changedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicationId.present) {
      map['medication_id'] = Variable<int>(medicationId.value);
    }
    if (oldValue.present) {
      map['old_value'] = Variable<double>(oldValue.value);
    }
    if (oldUnit.present) {
      map['old_unit'] = Variable<String>(oldUnit.value);
    }
    if (newValue.present) {
      map['new_value'] = Variable<double>(newValue.value);
    }
    if (newUnit.present) {
      map['new_unit'] = Variable<String>(newUnit.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<String>(changedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DosageChangesTableCompanion(')
          ..write('id: $id, ')
          ..write('medicationId: $medicationId, ')
          ..write('oldValue: $oldValue, ')
          ..write('oldUnit: $oldUnit, ')
          ..write('newValue: $newValue, ')
          ..write('newUnit: $newUnit, ')
          ..write('reason: $reason, ')
          ..write('changedAt: $changedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MedicationsTableTable medicationsTable = $MedicationsTableTable(
    this,
  );
  late final $MedicationLogsTableTable medicationLogsTable =
      $MedicationLogsTableTable(this);
  late final $DosageChangesTableTable dosageChangesTable =
      $DosageChangesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    medicationsTable,
    medicationLogsTable,
    dosageChangesTable,
  ];
}

typedef $$MedicationsTableTableCreateCompanionBuilder =
    MedicationsTableCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      required double dosageValue,
      required String dosageUnit,
      Value<int?> frequencyPerDay,
      Value<double?> intervalHours,
      required String times,
      required int color,
      Value<String?> icon,
      Value<bool> isArchived,
      Value<bool> isCompleted,
      Value<String?> notes,
      Value<String> startDate,
      Value<String?> endDate,
      Value<int?> remainingPills,
      required String createdAt,
      required String updatedAt,
    });
typedef $$MedicationsTableTableUpdateCompanionBuilder =
    MedicationsTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<double> dosageValue,
      Value<String> dosageUnit,
      Value<int?> frequencyPerDay,
      Value<double?> intervalHours,
      Value<String> times,
      Value<int> color,
      Value<String?> icon,
      Value<bool> isArchived,
      Value<bool> isCompleted,
      Value<String?> notes,
      Value<String> startDate,
      Value<String?> endDate,
      Value<int?> remainingPills,
      Value<String> createdAt,
      Value<String> updatedAt,
    });

final class $$MedicationsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MedicationsTableTable,
          MedicationsTableData
        > {
  $$MedicationsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $MedicationLogsTableTable,
    List<MedicationLogsTableData>
  >
  _medicationLogsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.medicationLogsTable,
        aliasName:
            'medications_table__id__medication_logs_table__medication_id',
      );

  $$MedicationLogsTableTableProcessedTableManager get medicationLogsTableRefs {
    final manager = $$MedicationLogsTableTableTableManager(
      $_db,
      $_db.medicationLogsTable,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _medicationLogsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DosageChangesTableTable,
    List<DosageChangesTableData>
  >
  _dosageChangesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.dosageChangesTable,
        aliasName: 'medications_table__id__dosage_changes_table__medication_id',
      );

  $$DosageChangesTableTableProcessedTableManager get dosageChangesTableRefs {
    final manager = $$DosageChangesTableTableTableManager(
      $_db,
      $_db.dosageChangesTable,
    ).filter((f) => f.medicationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dosageChangesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTableTable> {
  $$MedicationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dosageValue => $composableBuilder(
    column: $table.dosageValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosageUnit => $composableBuilder(
    column: $table.dosageUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frequencyPerDay => $composableBuilder(
    column: $table.frequencyPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get intervalHours => $composableBuilder(
    column: $table.intervalHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get times => $composableBuilder(
    column: $table.times,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remainingPills => $composableBuilder(
    column: $table.remainingPills,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> medicationLogsTableRefs(
    Expression<bool> Function($$MedicationLogsTableTableFilterComposer f) f,
  ) {
    final $$MedicationLogsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicationLogsTable,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationLogsTableTableFilterComposer(
            $db: $db,
            $table: $db.medicationLogsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dosageChangesTableRefs(
    Expression<bool> Function($$DosageChangesTableTableFilterComposer f) f,
  ) {
    final $$DosageChangesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dosageChangesTable,
      getReferencedColumn: (t) => t.medicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DosageChangesTableTableFilterComposer(
            $db: $db,
            $table: $db.dosageChangesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTableTable> {
  $$MedicationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dosageValue => $composableBuilder(
    column: $table.dosageValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosageUnit => $composableBuilder(
    column: $table.dosageUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frequencyPerDay => $composableBuilder(
    column: $table.frequencyPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get intervalHours => $composableBuilder(
    column: $table.intervalHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get times => $composableBuilder(
    column: $table.times,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remainingPills => $composableBuilder(
    column: $table.remainingPills,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTableTable> {
  $$MedicationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get dosageValue => $composableBuilder(
    column: $table.dosageValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dosageUnit => $composableBuilder(
    column: $table.dosageUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get frequencyPerDay => $composableBuilder(
    column: $table.frequencyPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<double> get intervalHours => $composableBuilder(
    column: $table.intervalHours,
    builder: (column) => column,
  );

  GeneratedColumn<String> get times =>
      $composableBuilder(column: $table.times, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get remainingPills => $composableBuilder(
    column: $table.remainingPills,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> medicationLogsTableRefs<T extends Object>(
    Expression<T> Function($$MedicationLogsTableTableAnnotationComposer a) f,
  ) {
    final $$MedicationLogsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.medicationLogsTable,
          getReferencedColumn: (t) => t.medicationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MedicationLogsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.medicationLogsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> dosageChangesTableRefs<T extends Object>(
    Expression<T> Function($$DosageChangesTableTableAnnotationComposer a) f,
  ) {
    final $$DosageChangesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dosageChangesTable,
          getReferencedColumn: (t) => t.medicationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DosageChangesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.dosageChangesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MedicationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationsTableTable,
          MedicationsTableData,
          $$MedicationsTableTableFilterComposer,
          $$MedicationsTableTableOrderingComposer,
          $$MedicationsTableTableAnnotationComposer,
          $$MedicationsTableTableCreateCompanionBuilder,
          $$MedicationsTableTableUpdateCompanionBuilder,
          (MedicationsTableData, $$MedicationsTableTableReferences),
          MedicationsTableData,
          PrefetchHooks Function({
            bool medicationLogsTableRefs,
            bool dosageChangesTableRefs,
          })
        > {
  $$MedicationsTableTableTableManager(
    _$AppDatabase db,
    $MedicationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double> dosageValue = const Value.absent(),
                Value<String> dosageUnit = const Value.absent(),
                Value<int?> frequencyPerDay = const Value.absent(),
                Value<double?> intervalHours = const Value.absent(),
                Value<String> times = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<int?> remainingPills = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
              }) => MedicationsTableCompanion(
                id: id,
                name: name,
                description: description,
                dosageValue: dosageValue,
                dosageUnit: dosageUnit,
                frequencyPerDay: frequencyPerDay,
                intervalHours: intervalHours,
                times: times,
                color: color,
                icon: icon,
                isArchived: isArchived,
                isCompleted: isCompleted,
                notes: notes,
                startDate: startDate,
                endDate: endDate,
                remainingPills: remainingPills,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                required double dosageValue,
                required String dosageUnit,
                Value<int?> frequencyPerDay = const Value.absent(),
                Value<double?> intervalHours = const Value.absent(),
                required String times,
                required int color,
                Value<String?> icon = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<int?> remainingPills = const Value.absent(),
                required String createdAt,
                required String updatedAt,
              }) => MedicationsTableCompanion.insert(
                id: id,
                name: name,
                description: description,
                dosageValue: dosageValue,
                dosageUnit: dosageUnit,
                frequencyPerDay: frequencyPerDay,
                intervalHours: intervalHours,
                times: times,
                color: color,
                icon: icon,
                isArchived: isArchived,
                isCompleted: isCompleted,
                notes: notes,
                startDate: startDate,
                endDate: endDate,
                remainingPills: remainingPills,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicationsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                medicationLogsTableRefs = false,
                dosageChangesTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (medicationLogsTableRefs) db.medicationLogsTable,
                    if (dosageChangesTableRefs) db.dosageChangesTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (medicationLogsTableRefs)
                        await $_getPrefetchedData<
                          MedicationsTableData,
                          $MedicationsTableTable,
                          MedicationLogsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$MedicationsTableTableReferences
                              ._medicationLogsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicationsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).medicationLogsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (dosageChangesTableRefs)
                        await $_getPrefetchedData<
                          MedicationsTableData,
                          $MedicationsTableTable,
                          DosageChangesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$MedicationsTableTableReferences
                              ._dosageChangesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicationsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).dosageChangesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicationId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MedicationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationsTableTable,
      MedicationsTableData,
      $$MedicationsTableTableFilterComposer,
      $$MedicationsTableTableOrderingComposer,
      $$MedicationsTableTableAnnotationComposer,
      $$MedicationsTableTableCreateCompanionBuilder,
      $$MedicationsTableTableUpdateCompanionBuilder,
      (MedicationsTableData, $$MedicationsTableTableReferences),
      MedicationsTableData,
      PrefetchHooks Function({
        bool medicationLogsTableRefs,
        bool dosageChangesTableRefs,
      })
    >;
typedef $$MedicationLogsTableTableCreateCompanionBuilder =
    MedicationLogsTableCompanion Function({
      Value<int> id,
      required int medicationId,
      required String scheduledTime,
      Value<String?> takenTime,
      required String status,
      Value<double?> dosageTaken,
      Value<String?> notes,
      required String createdAt,
    });
typedef $$MedicationLogsTableTableUpdateCompanionBuilder =
    MedicationLogsTableCompanion Function({
      Value<int> id,
      Value<int> medicationId,
      Value<String> scheduledTime,
      Value<String?> takenTime,
      Value<String> status,
      Value<double?> dosageTaken,
      Value<String?> notes,
      Value<String> createdAt,
    });

final class $$MedicationLogsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MedicationLogsTableTable,
          MedicationLogsTableData
        > {
  $$MedicationLogsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTableTable _medicationIdTable(_$AppDatabase db) =>
      db.medicationsTable.createAlias(
        'medication_logs_table__medication_id__medications_table__id',
      );

  $$MedicationsTableTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<int>('medication_id')!;

    final manager = $$MedicationsTableTableTableManager(
      $_db,
      $_db.medicationsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicationLogsTableTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationLogsTableTable> {
  $$MedicationLogsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get takenTime => $composableBuilder(
    column: $table.takenTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dosageTaken => $composableBuilder(
    column: $table.dosageTaken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableTableFilterComposer get medicationId {
    final $$MedicationsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medicationsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableTableFilterComposer(
            $db: $db,
            $table: $db.medicationsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationLogsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationLogsTableTable> {
  $$MedicationLogsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get takenTime => $composableBuilder(
    column: $table.takenTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dosageTaken => $composableBuilder(
    column: $table.dosageTaken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableTableOrderingComposer get medicationId {
    final $$MedicationsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medicationsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableTableOrderingComposer(
            $db: $db,
            $table: $db.medicationsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationLogsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationLogsTableTable> {
  $$MedicationLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scheduledTime => $composableBuilder(
    column: $table.scheduledTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get takenTime =>
      $composableBuilder(column: $table.takenTime, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get dosageTaken => $composableBuilder(
    column: $table.dosageTaken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MedicationsTableTableAnnotationComposer get medicationId {
    final $$MedicationsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medicationsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.medicationsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicationLogsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationLogsTableTable,
          MedicationLogsTableData,
          $$MedicationLogsTableTableFilterComposer,
          $$MedicationLogsTableTableOrderingComposer,
          $$MedicationLogsTableTableAnnotationComposer,
          $$MedicationLogsTableTableCreateCompanionBuilder,
          $$MedicationLogsTableTableUpdateCompanionBuilder,
          (MedicationLogsTableData, $$MedicationLogsTableTableReferences),
          MedicationLogsTableData,
          PrefetchHooks Function({bool medicationId})
        > {
  $$MedicationLogsTableTableTableManager(
    _$AppDatabase db,
    $MedicationLogsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationLogsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MedicationLogsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> medicationId = const Value.absent(),
                Value<String> scheduledTime = const Value.absent(),
                Value<String?> takenTime = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double?> dosageTaken = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => MedicationLogsTableCompanion(
                id: id,
                medicationId: medicationId,
                scheduledTime: scheduledTime,
                takenTime: takenTime,
                status: status,
                dosageTaken: dosageTaken,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int medicationId,
                required String scheduledTime,
                Value<String?> takenTime = const Value.absent(),
                required String status,
                Value<double?> dosageTaken = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required String createdAt,
              }) => MedicationLogsTableCompanion.insert(
                id: id,
                medicationId: medicationId,
                scheduledTime: scheduledTime,
                takenTime: takenTime,
                status: status,
                dosageTaken: dosageTaken,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicationLogsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.medicationId,
                                referencedTable:
                                    $$MedicationLogsTableTableReferences
                                        ._medicationIdTable(db),
                                referencedColumn:
                                    $$MedicationLogsTableTableReferences
                                        ._medicationIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MedicationLogsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationLogsTableTable,
      MedicationLogsTableData,
      $$MedicationLogsTableTableFilterComposer,
      $$MedicationLogsTableTableOrderingComposer,
      $$MedicationLogsTableTableAnnotationComposer,
      $$MedicationLogsTableTableCreateCompanionBuilder,
      $$MedicationLogsTableTableUpdateCompanionBuilder,
      (MedicationLogsTableData, $$MedicationLogsTableTableReferences),
      MedicationLogsTableData,
      PrefetchHooks Function({bool medicationId})
    >;
typedef $$DosageChangesTableTableCreateCompanionBuilder =
    DosageChangesTableCompanion Function({
      Value<int> id,
      required int medicationId,
      required double oldValue,
      required String oldUnit,
      required double newValue,
      required String newUnit,
      Value<String?> reason,
      required String changedAt,
    });
typedef $$DosageChangesTableTableUpdateCompanionBuilder =
    DosageChangesTableCompanion Function({
      Value<int> id,
      Value<int> medicationId,
      Value<double> oldValue,
      Value<String> oldUnit,
      Value<double> newValue,
      Value<String> newUnit,
      Value<String?> reason,
      Value<String> changedAt,
    });

final class $$DosageChangesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DosageChangesTableTable,
          DosageChangesTableData
        > {
  $$DosageChangesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MedicationsTableTable _medicationIdTable(_$AppDatabase db) =>
      db.medicationsTable.createAlias(
        'dosage_changes_table__medication_id__medications_table__id',
      );

  $$MedicationsTableTableProcessedTableManager get medicationId {
    final $_column = $_itemColumn<int>('medication_id')!;

    final manager = $$MedicationsTableTableTableManager(
      $_db,
      $_db.medicationsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DosageChangesTableTableFilterComposer
    extends Composer<_$AppDatabase, $DosageChangesTableTable> {
  $$DosageChangesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get oldValue => $composableBuilder(
    column: $table.oldValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oldUnit => $composableBuilder(
    column: $table.oldUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get newValue => $composableBuilder(
    column: $table.newValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get newUnit => $composableBuilder(
    column: $table.newUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicationsTableTableFilterComposer get medicationId {
    final $$MedicationsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medicationsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableTableFilterComposer(
            $db: $db,
            $table: $db.medicationsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DosageChangesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DosageChangesTableTable> {
  $$DosageChangesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get oldValue => $composableBuilder(
    column: $table.oldValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oldUnit => $composableBuilder(
    column: $table.oldUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get newValue => $composableBuilder(
    column: $table.newValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get newUnit => $composableBuilder(
    column: $table.newUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicationsTableTableOrderingComposer get medicationId {
    final $$MedicationsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medicationsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableTableOrderingComposer(
            $db: $db,
            $table: $db.medicationsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DosageChangesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DosageChangesTableTable> {
  $$DosageChangesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get oldValue =>
      $composableBuilder(column: $table.oldValue, builder: (column) => column);

  GeneratedColumn<String> get oldUnit =>
      $composableBuilder(column: $table.oldUnit, builder: (column) => column);

  GeneratedColumn<double> get newValue =>
      $composableBuilder(column: $table.newValue, builder: (column) => column);

  GeneratedColumn<String> get newUnit =>
      $composableBuilder(column: $table.newUnit, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);

  $$MedicationsTableTableAnnotationComposer get medicationId {
    final $$MedicationsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicationId,
      referencedTable: $db.medicationsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicationsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.medicationsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DosageChangesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DosageChangesTableTable,
          DosageChangesTableData,
          $$DosageChangesTableTableFilterComposer,
          $$DosageChangesTableTableOrderingComposer,
          $$DosageChangesTableTableAnnotationComposer,
          $$DosageChangesTableTableCreateCompanionBuilder,
          $$DosageChangesTableTableUpdateCompanionBuilder,
          (DosageChangesTableData, $$DosageChangesTableTableReferences),
          DosageChangesTableData,
          PrefetchHooks Function({bool medicationId})
        > {
  $$DosageChangesTableTableTableManager(
    _$AppDatabase db,
    $DosageChangesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DosageChangesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DosageChangesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DosageChangesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> medicationId = const Value.absent(),
                Value<double> oldValue = const Value.absent(),
                Value<String> oldUnit = const Value.absent(),
                Value<double> newValue = const Value.absent(),
                Value<String> newUnit = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String> changedAt = const Value.absent(),
              }) => DosageChangesTableCompanion(
                id: id,
                medicationId: medicationId,
                oldValue: oldValue,
                oldUnit: oldUnit,
                newValue: newValue,
                newUnit: newUnit,
                reason: reason,
                changedAt: changedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int medicationId,
                required double oldValue,
                required String oldUnit,
                required double newValue,
                required String newUnit,
                Value<String?> reason = const Value.absent(),
                required String changedAt,
              }) => DosageChangesTableCompanion.insert(
                id: id,
                medicationId: medicationId,
                oldValue: oldValue,
                oldUnit: oldUnit,
                newValue: newValue,
                newUnit: newUnit,
                reason: reason,
                changedAt: changedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DosageChangesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.medicationId,
                                referencedTable:
                                    $$DosageChangesTableTableReferences
                                        ._medicationIdTable(db),
                                referencedColumn:
                                    $$DosageChangesTableTableReferences
                                        ._medicationIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DosageChangesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DosageChangesTableTable,
      DosageChangesTableData,
      $$DosageChangesTableTableFilterComposer,
      $$DosageChangesTableTableOrderingComposer,
      $$DosageChangesTableTableAnnotationComposer,
      $$DosageChangesTableTableCreateCompanionBuilder,
      $$DosageChangesTableTableUpdateCompanionBuilder,
      (DosageChangesTableData, $$DosageChangesTableTableReferences),
      DosageChangesTableData,
      PrefetchHooks Function({bool medicationId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MedicationsTableTableTableManager get medicationsTable =>
      $$MedicationsTableTableTableManager(_db, _db.medicationsTable);
  $$MedicationLogsTableTableTableManager get medicationLogsTable =>
      $$MedicationLogsTableTableTableManager(_db, _db.medicationLogsTable);
  $$DosageChangesTableTableTableManager get dosageChangesTable =>
      $$DosageChangesTableTableTableManager(_db, _db.dosageChangesTable);
}
