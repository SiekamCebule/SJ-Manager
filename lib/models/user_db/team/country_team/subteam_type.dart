import 'package:sj_manager/utils/multilingual_string.dart';

enum SubteamType {
  a,
  b,
  c,
  d,
  junior,
}

const subteamTypeNames = {
  SubteamType.a: MultilingualString(valuesByLanguage: {
    'pl': 'Kadra A',
    'en': 'Subteam A',
  }),
  SubteamType.b: MultilingualString(valuesByLanguage: {
    'pl': 'Kadra B',
    'en': 'Subteam B',
  }),
  SubteamType.c: MultilingualString(valuesByLanguage: {
    'pl': 'Kadra C',
    'en': 'Subteam C',
  }),
  SubteamType.d: MultilingualString(valuesByLanguage: {
    'pl': 'Kadra D',
    'en': 'Subteam D',
  }),
  SubteamType.junior: MultilingualString(valuesByLanguage: {
    'pl': 'Kadra Juniorska',
    'en': 'Subteam Junior',
  }),
};

const subteamTypeDescriptionsWhenChoosing = {
  SubteamType.a: MultilingualString(valuesByLanguage: {
    'pl': 'Kadra w której znajdują się najlepsi w kraju',
    'en': 'A subteam featuring the best athletes in the country',
  }),
  SubteamType.b: MultilingualString(valuesByLanguage: {
    'pl': 'Zaplecze kadry A, w której wciąż znajdziemy wiele talentów',
    'en': 'Subteam B, the backup to Subteam A, still packed with talent',
  }),
  SubteamType.c: MultilingualString(valuesByLanguage: {
    'pl':
        'Są tu sportowcy, którzy tylko czekają na trenera, który pomoże im się rozwinąć',
    'en': 'Jumpers here are waiting for the coach, who can unlock their potential',
  }),
  SubteamType.d: MultilingualString(valuesByLanguage: {
    'pl':
        'Jest to dopiero czwarta z koleji kadra, ale ci goście wciąż umieją skakać na nartach!',
    'en': 'It\'s only the fourth tier, but these guys can still ski jump!',
  }),
  SubteamType.junior: MultilingualString(valuesByLanguage: {
    'pl':
        'W tej kadrze znajdują się młode talenty, które wielkie skakanie mają jeszcze przed sobą',
    'en': 'That subteam contains young talents with a bright future ahead in ski jumping',
  }),
};
