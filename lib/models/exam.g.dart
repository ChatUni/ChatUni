// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question()
  ..number = (json['number'] as num).toInt()
  ..answer = json['answer'] as String?
  ..userAnswer = json['userAnswer'] as String?
  ..score = json['score'] as String?
  ..subject = json['subject'] as String?
  ..choices =
      (json['choices'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..images =
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..comp = (json['comp'] as num?)?.toInt();

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'number': instance.number,
      'answer': instance.answer,
      'userAnswer': instance.userAnswer,
      'score': instance.score,
      'subject': instance.subject,
      'choices': instance.choices,
      'images': instance.images,
      'comp': instance.comp,
    };

Paragraph _$ParagraphFromJson(Map<String, dynamic> json) => Paragraph()
  ..type = json['type'] as String
  ..content =
      (json['content'] as List<dynamic>).map((e) => e as String).toList()
  ..questions = (json['questions'] as List<dynamic>?)
      ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
      .toList()
  ..maxChoice = json['maxChoice'] as String?;

Map<String, dynamic> _$ParagraphToJson(Paragraph instance) => <String, dynamic>{
      'type': instance.type,
      'content': instance.content,
      'questions': instance.questions,
      'maxChoice': instance.maxChoice,
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

TestJ _$TestJFromJson(Map<String, dynamic> json) => TestJ()
  ..id = json['id'] as String
  ..title = json['title'] as String?
  ..listen = (json['listen'] as List<dynamic>?)
      ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
      .toList()
  ..read = (json['read'] as List<dynamic>?)
      ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
      .toList()
  ..read1 = (json['read1'] as List<dynamic>?)
      ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
      .toList()
  ..read2 = (json['read2'] as List<dynamic>?)
      ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
      .toList()
  ..write = (json['write'] as List<dynamic>?)
      ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
      .toList()
  ..speak = (json['speak'] as List<dynamic>?)
      ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
      .toList()
  ..math1 = (json['math1'] as List<dynamic>?)
      ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
      .toList()
  ..math2 = (json['math2'] as List<dynamic>?)
      ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
      .toList()
  ..test = (json['test'] as List<dynamic>?)
      ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TestJToJson(TestJ instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'listen': instance.listen,
      'read': instance.read,
      'read1': instance.read1,
      'read2': instance.read2,
      'write': instance.write,
      'speak': instance.speak,
      'math1': instance.math1,
      'math2': instance.math2,
      'test': instance.test,
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result()
  ..userId = json['userId'] as String
  ..testId = json['testId'] as String
  ..type = json['type'] as String
  ..date = json['date'] as String
  ..questions = (json['questions'] as List<dynamic>)
      .map((e) => Question.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'userId': instance.userId,
      'testId': instance.testId,
      'type': instance.type,
      'date': instance.date,
      'questions': instance.questions,
    };

Explanation _$ExplanationFromJson(Map<String, dynamic> json) => Explanation()
  ..questions = (json['questions'] as List<dynamic>)
      .map((e) => ExQuestion.fromJson(e as Map<String, dynamic>))
      .toList()
  ..similar_questions = (json['similar_questions'] as List<dynamic>?)
      ?.map((e) => ExQuestion.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ExplanationToJson(Explanation instance) =>
    <String, dynamic>{
      'questions': instance.questions,
      'similar_questions': instance.similar_questions,
    };

ExQuestion _$ExQuestionFromJson(Map<String, dynamic> json) => ExQuestion()
  ..num = (json['num'] as num?)?.toInt()
  ..question = json['question'] as String?
  ..options =
      (json['options'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..answer = json['answer'] as String?
  ..answers =
      (json['answers'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..explanation = json['explanation'] as String?;

Map<String, dynamic> _$ExQuestionToJson(ExQuestion instance) =>
    <String, dynamic>{
      'num': instance.num,
      'question': instance.question,
      'options': instance.options,
      'answer': instance.answer,
      'answers': instance.answers,
      'explanation': instance.explanation,
    };
