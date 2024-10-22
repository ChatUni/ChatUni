// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ielts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question()
  ..number = (json['number'] as num).toInt()
  ..answer = json['answer'] as String?
  ..userAnswer = json['userAnswer'] as String?
  ..subject = json['subject'] as String?
  ..choices =
      (json['choices'] as List<dynamic>?)?.map((e) => e as String).toList();

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'number': instance.number,
      'answer': instance.answer,
      'userAnswer': instance.userAnswer,
      'subject': instance.subject,
      'choices': instance.choices,
    };

Paragraph _$ParagraphFromJson(Map<String, dynamic> json) => Paragraph()
  ..type = json['type'] as String
  ..content =
      (json['content'] as List<dynamic>).map((e) => e as String).toList()
  ..questions = (json['questions'] as List<dynamic>?)
      ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ParagraphToJson(Paragraph instance) => <String, dynamic>{
      'type': instance.type,
      'content': instance.content,
      'questions': instance.questions,
    };

Group _$GroupFromJson(Map<String, dynamic> json) => Group()
  ..name = json['name'] as String
  ..from = (json['from'] as num).toInt()
  ..to = (json['to'] as num).toInt()
  ..paragraphs = (json['paragraphs'] as List<dynamic>)
      .map((e) => Paragraph.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'name': instance.name,
      'from': instance.from,
      'to': instance.to,
      'paragraphs': instance.paragraphs,
    };

Part _$PartFromJson(Map<String, dynamic> json) => Part()
  ..name = json['name'] as String
  ..from = (json['from'] as num).toInt()
  ..to = (json['to'] as num).toInt()
  ..groups = (json['groups'] as List<dynamic>)
      .map((e) => Group.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$PartToJson(Part instance) => <String, dynamic>{
      'name': instance.name,
      'from': instance.from,
      'to': instance.to,
      'groups': instance.groups,
    };

Test _$TestFromJson(Map<String, dynamic> json) => Test()
  ..id = json['id'] as String
  ..listen = (json['listen'] as List<dynamic>)
      .map((e) => Part.fromJson(e as Map<String, dynamic>))
      .toList()
  ..read = (json['read'] as List<dynamic>)
      .map((e) => Part.fromJson(e as Map<String, dynamic>))
      .toList()
  ..write = (json['write'] as List<dynamic>)
      .map((e) => Part.fromJson(e as Map<String, dynamic>))
      .toList()
  ..speak = (json['speak'] as List<dynamic>)
      .map((e) => Part.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TestToJson(Test instance) => <String, dynamic>{
      'id': instance.id,
      'listen': instance.listen,
      'read': instance.read,
      'write': instance.write,
      'speak': instance.speak,
    };
