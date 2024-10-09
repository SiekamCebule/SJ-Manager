import 'package:sj_manager/utils/multilingual_string.dart';

enum SubteamType {
  a,
  b,
  c,
  d,
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
};

const subteamTypeDescriptionsWhenChoosing = {
  SubteamType.a: MultilingualString(valuesByLanguage: {
    'pl': 'Kadra w której znajdują się najlepsi w kraju',
    'en': 'A subteam featuring the best athletes in the country',
  }),
  SubteamType.b: MultilingualString(valuesByLanguage: {
    'pl': 'Zaplecze kadry A, w której wciąż znajdziemy wiele talentów',
    'en': 'The backup to Subteam A, still packed with talent',
  }),
  SubteamType.c: MultilingualString(valuesByLanguage: {
    'pl': 'Są tu sportowcy z potencjałem, którzy tylko czekają na odpowiedniego trenera',
    'en': 'Jumpers here are waiting for the coach, who can unlock their potential',
  }),
  SubteamType.d: MultilingualString(valuesByLanguage: {
    'pl':
        'Nie ma tu zachwycającego poziomu, ale ci ludzie wciąż potrafią skakać na nartach!',
    'en':
        'The level here might not be impressive, but these athletes can still ski jump!',
  }),
};
