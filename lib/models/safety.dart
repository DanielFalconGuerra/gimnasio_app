class LegalAgreement {
  final String id;
  final String title;
  final String content;
  final int version;
  bool accepted;
  DateTime? acceptedAt;

  LegalAgreement({
    required this.id,
    required this.title,
    required this.content,
    required this.version,
    this.accepted = false,
    this.acceptedAt,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'title': title,
        'content': content,
        'version': version,
        'accepted': accepted,
        'acceptedAt': acceptedAt?.toIso8601String(),
      };

  factory LegalAgreement.fromMap(Map<String, dynamic> map) => LegalAgreement(
        id: map['id'] as String? ?? '',
        title: map['title'] as String? ?? '',
        content: map['content'] as String? ?? '',
        version: map['version'] as int? ?? 1,
        accepted: map['accepted'] as bool? ?? false,
        acceptedAt: map['acceptedAt'] != null 
            ? DateTime.parse(map['acceptedAt'] as String)
            : null,
      );
}

class SafetyProfile {
  String userId;
  bool legalAgreed;
  DateTime? lastLegalAgreementDate;
  int totalWorkouts;
  int injuryIncidents;

  SafetyProfile({
    required this.userId,
    this.legalAgreed = false,
    this.lastLegalAgreementDate,
    this.totalWorkouts = 0,
    this.injuryIncidents = 0,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        'userId': userId,
        'legalAgreed': legalAgreed,
        'lastLegalAgreementDate': lastLegalAgreementDate?.toIso8601String(),
        'totalWorkouts': totalWorkouts,
        'injuryIncidents': injuryIncidents,
      };

  factory SafetyProfile.fromMap(Map<String, dynamic> map) => SafetyProfile(
        userId: map['userId'] as String? ?? '',
        legalAgreed: map['legalAgreed'] as bool? ?? false,
        lastLegalAgreementDate: map['lastLegalAgreementDate'] != null
            ? DateTime.parse(map['lastLegalAgreementDate'] as String)
            : null,
        totalWorkouts: map['totalWorkouts'] as int? ?? 0,
        injuryIncidents: map['injuryIncidents'] as int? ?? 0,
      );
}
