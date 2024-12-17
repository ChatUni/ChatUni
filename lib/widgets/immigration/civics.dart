import 'package:flutter/material.dart';

class CivicsQuestionsScreen extends StatelessWidget {
  CivicsQuestionsScreen({super.key});

  // JSON Data: Parsed into a List of Maps
  final List<Map<String, dynamic>> questions = [
    {
      'Section': 'A: Principles of American Democracy',
      'Number': 1,
      'Question': 'What is the supreme law of the land?',
      'Answer': ['the Constitution'],
    },
    {
      'Section': 'A: Principles of American Democracy',
      'Number': 2,
      'Question': 'What does the Constitution do?',
      'Answer': [
        'sets up the government',
        'defines the government',
        'protects basic rights of Americans',
      ],
    },
    {
      'Section': 'A: Principles of American Democracy',
      'Number': 3,
      'Question':
          'The idea of self-government is in the first three words of the Constitution. What are these words?',
      'Answer': ['We the People'],
    },
    {
      'Section': 'A: Principles of American Democracy',
      'Number': 4,
      'Question': 'What is an amendment?',
      'Answer': [
        'a change (to the Constitution)',
        'an addition (to the Constitution)',
      ],
    },
    {
      'Section': 'A: Principles of American Democracy',
      'Number': 5,
      'Question':
          'What do we call the first ten amendments to the Constitution?',
      'Answer': ['the Bill of Rights'],
    },
    {
      'Section': 'A: Principles of American Democracy',
      'Number': 6,
      'Question': 'What is one right or freedom from the First Amendment?*',
      'Answer': [
        'speech',
        'religion',
        'assembly',
        'press',
        'petition the government',
      ],
    },
    {
      'Section': 'A: Principles of American Democracy',
      'Number': 7,
      'Question': 'How many amendments does the Constitution have?',
      'Answer': ['twenty-seven (27)'],
    },
    {
      'Section': 'A: Principles of American Democracy',
      'Number': 8,
      'Question': 'What did the Declaration of Independence do?',
      'Answer': [
        'announced our independence (from Great Britain)',
        'declared our independence (from Great Britain)',
        'said that the United States is free (from Great Britain)',
      ],
    },
    {
      'Section': 'A: Principles of American Democracy',
      'Number': 9,
      'Question': 'What are two rights in the Declaration of Independence?',
      'Answer': ['life', 'liberty', 'pursuit of happiness'],
    },
    {
      'Section': 'A: Principles of American Democracy',
      'Number': 10,
      'Question': 'What is freedom of religion?',
      'Answer': ['You can practice any religion, or not practice a religion.'],
    },
    {
      'Section': 'A: Principles of American Democracy',
      'Number': 11,
      'Question': 'What is the economic system in the United States?*',
      'Answer': ['capitalist economy', 'market economy'],
    },
    {
      'Section': 'A: Principles of American Democracy',
      'Number': 12,
      'Question': 'What is the "rule of law"?',
      'Answer': [
        'Everyone must follow the law.',
        'Leaders must obey the law.',
        'Government must obey the law.',
        'No one is above the law.',
      ],
    },
    {
      'Section': 'B: System of Government',
      'Number': 13,
      'Question': 'Name one branch or part of the government.*',
      'Answer': [
        'Congress',
        'legislative',
        'President',
        'executive',
        'the courts',
        'judicial',
      ],
    },
    {
      'Section': 'B: System of Government',
      'Number': 14,
      'Question':
          'What stops one branch of government from becoming too powerful?',
      'Answer': ['checks and balances', 'separation of powers'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 15,
      'Question': 'Who is in charge of the executive branch?',
      'Answer': ['the President'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 16,
      'Question': 'Who makes federal laws?',
      'Answer': [
        'Congress',
        'Senate and House (of Representatives)',
        '(U.S. or national) legislature',
      ],
    },
    {
      'Section': 'B: System of Government',
      'Number': 17,
      'Question': 'What are the two parts of the U.S. Congress?*',
      'Answer': ['the Senate and House (of Representatives)'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 18,
      'Question': 'How many U.S. Senators are there?',
      'Answer': ['one hundred (100)'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 19,
      'Question': 'We elect a U.S. Senator for how many years?',
      'Answer': ['six (6)'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 20,
      'Question': 'Who is one of your state’s U.S. Senators now?*',
      'Answer': [
        'Answers will vary. [District of Columbia residents and residents of U.S. territories should answer that D.C. (or the territory where the applicant lives) has no U.S. Senators.]',
      ],
    },
    {
      'Section': 'B: System of Government',
      'Number': 21,
      'Question': 'The House of Representatives has how many voting members?',
      'Answer': ['four hundred thirty-five (435)'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 22,
      'Question': 'We elect a U.S. Representative for how many years?',
      'Answer': ['two (2)'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 23,
      'Question': 'Name your U.S. Representative.',
      'Answer': [
        'Answers will vary. [Residents of territories with nonvoting Delegates or Resident Commissioners may provide the name of that Delegate or Commissioner. Also acceptable is any statement that the territory has no (voting) Representatives in Congress.]',
      ],
    },
    {
      'Section': 'B: System of Government',
      'Number': 24,
      'Question': 'Who does a U.S. Senator represent?',
      'Answer': ['all people of the state'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 25,
      'Question':
          'Why do some states have more Representatives than other states?',
      'Answer': [
        '(because of) the state’s population',
        '(because) they have more people',
        '(because) some states have more people',
      ],
    },
    {
      'Section': 'B: System of Government',
      'Number': 26,
      'Question': 'We elect a President for how many years?',
      'Answer': ['four (4)'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 27,
      'Question': 'In what month do we vote for President?*',
      'Answer': ['November'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 28,
      'Question':
          'What is the name of the President of the United States now?*',
      'Answer': [
        'Visit uscis.gov/citizenship/testupdates for the name of the President of the United States.',
      ],
    },
    {
      'Section': 'B: System of Government',
      'Number': 29,
      'Question':
          'What is the name of the Vice President of the United States now?',
      'Answer': [
        'Visit uscis.gov/citizenship/testupdates for the name of the Vice President of the United States.',
      ],
    },
    {
      'Section': 'B: System of Government',
      'Number': 30,
      'Question':
          'If the President can no longer serve, who becomes President?',
      'Answer': ['the Vice President'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 31,
      'Question':
          'If both the President and the Vice President can no longer serve, who becomes President?',
      'Answer': ['the Speaker of the House'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 32,
      'Question': 'Who is the Commander in Chief of the military?',
      'Answer': ['the President'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 33,
      'Question': 'Who signs bills to become laws?',
      'Answer': ['the President'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 34,
      'Question': 'Who vetoes bills?',
      'Answer': ['the President'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 35,
      'Question': 'What does the President’s Cabinet do?',
      'Answer': ['advises the President'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 36,
      'Question': 'What are two Cabinet-level positions?',
      'Answer': [
        'Secretary of Agriculture',
        'Secretary of Commerce',
        'Secretary of Defense',
        'Secretary of Education',
        'Secretary of Energy',
        'Secretary of Health and Human Services',
        'Secretary of Homeland Security',
        'Secretary of Housing and Urban Development',
        'Secretary of the Interior',
        'Secretary of Labor',
        'Secretary of State',
        'Secretary of Transportation',
        'Secretary of the Treasury',
        'Secretary of Veterans Affairs',
        'Attorney General',
        'Vice President',
      ],
    },
    {
      'Section': 'B: System of Government',
      'Number': 37,
      'Question': 'What does the judicial branch do?',
      'Answer': [
        'reviews laws',
        'explains laws',
        'resolves disputes (disagreements)',
        'decides if a law goes against the Constitution',
      ],
    },
    {
      'Section': 'B: System of Government',
      'Number': 38,
      'Question': 'What is the highest court in the United States?',
      'Answer': ['the Supreme Court'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 39,
      'Question': 'How many justices are on the Supreme Court?',
      'Answer': [
        'Visit uscis.gov/citizenship/testupdates for the number of justices on the Supreme Court.',
      ],
    },
    {
      'Section': 'B: System of Government',
      'Number': 40,
      'Question': 'Who is the Chief Justice of the United States now?',
      'Answer': [
        'Visit uscis.gov/citizenship/testupdates for the name of the Chief Justice of the United States.',
      ],
    },
    {
      'Section': 'B: System of Government',
      'Number': 41,
      'Question':
          'Under our Constitution, some powers belong to the federal government. What is one power of the federal government?',
      'Answer': [
        'to print money',
        'to declare war',
        'to create an army',
        'to make treaties',
      ],
    },
    {
      'Section': 'B: System of Government',
      'Number': 42,
      'Question':
          'Under our Constitution, some powers belong to the states. What is one power of the states?',
      'Answer': [
        'provide schooling and education',
        'provide protection (police)',
        'provide safety (fire departments)',
        'give a driver’s license',
        'approve zoning and land use',
      ],
    },
    {
      'Section': 'B: System of Government',
      'Number': 43,
      'Question': 'Who is the Governor of your state now?',
      'Answer': [
        'Answers will vary. [District of Columbia residents should answer that D.C. does not have a Governor.]',
      ],
    },
    {
      'Section': 'B: System of Government',
      'Number': 44,
      'Question': 'What is the capital of your state?*',
      'Answer': [
        'Answers will vary. [District of Columbia residents should answer that D.C. is not a state and does not have a capital. Residents of U.S. territories should name the capital of the territory.',
      ],
    },
    {
      'Section': 'B: System of Government',
      'Number': 45,
      'Question':
          'What are the two major political parties in the United States?*',
      'Answer': ['Democratic and Republican'],
    },
    {
      'Section': 'B: System of Government',
      'Number': 46,
      'Question': 'What is the political party of the President now?',
      'Answer': [
        'Visit uscis.gov/citizenship/testupdates for the political party of the President.',
      ],
    },
    {
      'Section': 'B: System of Government',
      'Number': 47,
      'Question':
          'What is the name of the Speaker of the House of Representatives now?',
      'Answer': [
        'Visit uscis.gov/citizenship/testupdates for the name of the Speaker of the House of Representatives.',
      ],
    },
    {
      'Section': 'C: Rights and Responsibilities',
      'Number': 48,
      'Question':
          'There are four amendments to the Constitution about who can vote. Describe one of them.',
      'Answer': [
        'Citizens eighteen (18) and older (can vote).',
        'You don’t have to pay (a poll tax) to vote.',
        'Any citizen can vote. (Women and men can vote.)',
        'A male citizen of any race (can vote).',
      ],
    },
    {
      'Section': 'C: Rights and Responsibilities',
      'Number': 49,
      'Question':
          'What is one responsibility that is only for United States citizens?*',
      'Answer': [
        'serve on a jury',
        'vote in a federal election',
      ],
    },
    {
      'Section': 'C: Rights and Responsibilities',
      'Number': 50,
      'Question': 'Name one right only for United States citizens.',
      'Answer': [
        'vote in a federal election',
        'run for federal office',
      ],
    },
    {
      'Section': 'C: Rights and Responsibilities',
      'Number': 51,
      'Question':
          'What are two rights of everyone living in the United States?',
      'Answer': [
        'freedom of expression',
        'freedom of speech',
        'freedom of assembly',
        'freedom to petition the government',
        'freedom of religion',
        'the right to bear arms',
      ],
    },
    {
      'Section': 'C: Rights and Responsibilities',
      'Number': 52,
      'Question':
          'What do we show loyalty to when we say the Pledge of Allegiance?',
      'Answer': [
        'the United States',
        'the flag',
      ],
    },
    {
      'Section': 'C: Rights and Responsibilities',
      'Number': 53,
      'Question':
          'What is one promise you make when you become a United States citizen?',
      'Answer': [
        'give up loyalty to other countries',
        'defend the Constitution and laws of the United States',
        'obey the laws of the United States',
        'serve in the U.S. military (if needed)',
        'serve (do important work for) the nation (if needed)',
        'be loyal to the United States',
      ],
    },
    {
      'Section': 'C: Rights and Responsibilities',
      'Number': 54,
      'Question': 'How old do citizens have to be to vote for President?*',
      'Answer': ['eighteen (18) and older'],
    },
    {
      'Section': 'C: Rights and Responsibilities',
      'Number': 55,
      'Question':
          'What are two ways that Americans can participate in their democracy?',
      'Answer': [
        'vote',
        'join a political party',
        'help with a campaign',
        'join a civic group',
        'join a community group',
        'give an elected official your opinion on an issue',
        'call Senators and Representatives',
        'publicly support or oppose an issue or policy',
        'run for office',
        'write to a newspaper',
      ],
    },
    {
      'Section': 'C: Rights and Responsibilities',
      'Number': 56,
      'Question':
          'When is the last day you can send in federal income tax forms?*',
      'Answer': ['April 15'],
    },
    {
      'Section': 'C: Rights and Responsibilities',
      'Number': 57,
      'Question': 'When must all men register for the Selective Service?',
      'Answer': [
        'at age eighteen (18)',
        'between eighteen (18) and twenty-six (26)',
      ],
    },
    {
      'Section': 'A: Colonial Period and Independence',
      'Number': 58,
      'Question': 'What is one reason colonists came to America?',
      'Answer': [
        'freedom',
        'political liberty',
        'religious freedom',
        'economic opportunity',
        'practice their religion',
        'escape persecution',
      ],
    },
    {
      'Section': 'A: Colonial Period and Independence',
      'Number': 59,
      'Question': 'Who lived in America before the Europeans arrived?',
      'Answer': [
        'American Indians',
        'Native Americans',
      ],
    },
    {
      'Section': 'A: Colonial Period and Independence',
      'Number': 60,
      'Question':
          'What group of people was taken to America and sold as slaves?',
      'Answer': [
        'Africans',
        'people from Africa',
      ],
    },
    {
      'Section': 'A: Colonial Period and Independence',
      'Number': 61,
      'Question': 'Why did the colonists fight the British?',
      'Answer': [
        'because of high taxes (taxation without representation)',
        'because the British army stayed in their houses (boarding, quartering)',
        'because they didn’t have self-government',
      ],
    },
    {
      'Section': 'A: Colonial Period and Independence',
      'Number': 62,
      'Question': 'Who wrote the Declaration of Independence?',
      'Answer': ['(Thomas) Jefferson'],
    },
    {
      'Section': 'A: Colonial Period and Independence',
      'Number': 63,
      'Question': 'When was the Declaration of Independence adopted?',
      'Answer': ['July 4, 1776'],
    },
    {
      'Section': 'A: Colonial Period and Independence',
      'Number': 64,
      'Question': 'There were 13 original states. Name three.',
      'Answer': [
        'New Hampshire',
        'Massachusetts',
        'Rhode Island',
        'Connecticut',
        'New York',
        'New Jersey',
        'Pennsylvania',
        'Delaware',
        'Maryland',
        'Virginia',
        'North Carolina',
        'South Carolina',
        'Georgia',
      ],
    },
    {
      'Section': 'A: Colonial Period and Independence',
      'Number': 65,
      'Question': 'What happened at the Constitutional Convention?',
      'Answer': [
        'The Constitution was written.',
        'The Founding Fathers wrote the Constitution.',
      ],
    },
    {
      'Section': 'A: Colonial Period and Independence',
      'Number': 66,
      'Question': 'When was the Constitution written?',
      'Answer': ['1787'],
    },
    {
      'Section': 'A: Colonial Period and Independence',
      'Number': 67,
      'Question':
          'The Federalist Papers supported the passage of the U.S. Constitution. Name one of the writers.',
      'Answer': [
        '(James) Madison',
        '(Alexander) Hamilton',
        '(John) Jay',
        'Publius',
      ],
    },
    {
      'Section': 'A: Colonial Period and Independence',
      'Number': 68,
      'Question': 'What is one thing Benjamin Franklin is famous for?',
      'Answer': [
        'U.S. diplomat',
        'oldest member of the Constitutional Convention',
        'first Postmaster General of the United States',
        'writer of "Poor Richard’s Almanac"',
        'started the first free libraries',
      ],
    },
    {
      'Section': 'A: Colonial Period and Independence',
      'Number': 69,
      'Question': 'Who is the "Father of Our Country"?',
      'Answer': ['(George) Washington'],
    },
    {
      'Section': 'A: Colonial Period and Independence',
      'Number': 70,
      'Question': 'Who was the first President?*',
      'Answer': ['(George) Washington'],
    },
    {
      'Section': 'B: 1800s',
      'Number': 71,
      'Question':
          'What territory did the United States buy from France in 1803?',
      'Answer': [
        'the Louisiana Territory',
        'Louisiana',
      ],
    },
    {
      'Section': 'B: 1800s',
      'Number': 72,
      'Question': 'Name one war fought by the United States in the 1800s.',
      'Answer': [
        'War of 1812',
        'Mexican-American War',
        'Civil War',
        'Spanish-American War',
      ],
    },
    {
      'Section': 'B: 1800s',
      'Number': 73,
      'Question': 'Name the U.S. war between the North and the South.',
      'Answer': [
        'the Civil War',
        'the War between the States',
      ],
    },
    {
      'Section': 'B: 1800s',
      'Number': 74,
      'Question': 'Name one problem that led to the Civil War.',
      'Answer': [
        'slavery',
        'economic reasons',
        'states’ rights',
      ],
    },
    {
      'Section': 'B: 1800s',
      'Number': 75,
      'Question': 'What was one important thing that Abraham Lincoln did?*',
      'Answer': [
        'freed the slaves (Emancipation Proclamation)',
        'saved (or preserved) the Union',
        'led the United States during the Civil War',
      ],
    },
    {
      'Section': 'B: 1800s',
      'Number': 76,
      'Question': 'What did the Emancipation Proclamation do?',
      'Answer': [
        'freed the slaves',
        'freed slaves in the Confederacy',
        'freed slaves in the Confederate states',
        'freed slaves in most Southern states',
      ],
    },
    {
      'Section': 'B: 1800s',
      'Number': 77,
      'Question': 'What did Susan B. Anthony do?',
      'Answer': [
        'fought for women’s rights',
        'fought for civil rights',
      ],
    },
    {
      'Section':
          'C: Recent American History and Other Important Historical Information',
      'Number': 78,
      'Question': 'Name one war fought by the United States in the 1900s.*',
      'Answer': [
        'World War I',
        'World War II',
        'Korean War',
        'Vietnam War',
        '(Persian) Gulf War',
      ],
    },
    {
      'Section':
          'C: Recent American History and Other Important Historical Information',
      'Number': 79,
      'Question': 'Who was President during World War I?',
      'Answer': ['(Woodrow) Wilson'],
    },
    {
      'Section':
          'C: Recent American History and Other Important Historical Information',
      'Number': 80,
      'Question':
          'Who was President during the Great Depression and World War II?',
      'Answer': ['(Franklin) Roosevelt'],
    },
    {
      'Section':
          'C: Recent American History and Other Important Historical Information',
      'Number': 81,
      'Question': 'Who did the United States fight in World War II?',
      'Answer': ['Japan, Germany, and Italy'],
    },
    {
      'Section':
          'C: Recent American History and Other Important Historical Information',
      'Number': 82,
      'Question':
          'Before he was President, Eisenhower was a general. What war was he in?',
      'Answer': ['World War II'],
    },
    {
      'Section':
          'C: Recent American History and Other Important Historical Information',
      'Number': 83,
      'Question':
          'During the Cold War, what was the main concern of the United States?',
      'Answer': ['Communism'],
    },
    {
      'Section':
          'C: Recent American History and Other Important Historical Information',
      'Number': 84,
      'Question': 'What movement tried to end racial discrimination?',
      'Answer': ['civil rights (movement)'],
    },
    {
      'Section':
          'C: Recent American History and Other Important Historical Information',
      'Number': 85,
      'Question': 'What did Martin Luther King, Jr. do?*',
      'Answer': [
        'fought for civil rights',
        'worked for equality for all Americans',
      ],
    },
    {
      'Section':
          'C: Recent American History and Other Important Historical Information',
      'Number': 86,
      'Question':
          'What major event happened on September 11, 2001, in the United States?',
      'Answer': ['Terrorists attacked the United States.'],
    },
    {
      'Section':
          'C: Recent American History and Other Important Historical Information',
      'Number': 87,
      'Question': 'Name one American Indian tribe in the United States.',
      'Answer': [
        'Cherokee',
        'Navajo',
        'Sioux',
        'Chippewa',
        'Choctaw',
        'Pueblo',
        'Apache',
        'Iroquois',
        'Creek',
        'Blackfeet',
        'Seminole',
        'Cheyenne',
        'Arawak',
        'Shawnee',
        'Mohegan',
        'Huron',
        'Oneida',
        'Lakota',
        'Crow',
        'Teton',
        'Hopi',
        'Inuit',
      ],
    },
    {
      'Section': 'Integrated Civics: Geography',
      'Number': 88,
      'Question': 'Name one of the two longest rivers in the United States.',
      'Answer': ['Missouri (River)', 'Mississippi (River)'],
    },
    {
      'Section': 'Integrated Civics: Geography',
      'Number': 89,
      'Question': 'What ocean is on the West Coast of the United States?',
      'Answer': ['Pacific (Ocean)'],
    },
    {
      'Section': 'Integrated Civics: Geography',
      'Number': 90,
      'Question': 'What ocean is on the East Coast of the United States?',
      'Answer': ['Atlantic (Ocean)'],
    },
    {
      'Section': 'Integrated Civics: Geography',
      'Number': 91,
      'Question': 'Name one U.S. territory.',
      'Answer': [
        'Puerto Rico',
        'U.S. Virgin Islands',
        'American Samoa',
        'Northern Mariana Islands',
        'Guam',
      ],
    },
    {
      'Section': 'Integrated Civics: Geography',
      'Number': 92,
      'Question': 'Name one state that borders Canada.',
      'Answer': [
        'Maine',
        'New Hampshire',
        'Vermont',
        'New York',
        'Pennsylvania',
        'Ohio',
        'Michigan',
        'Minnesota',
        'North Dakota',
        'Montana',
        'Idaho',
        'Washington',
        'Alaska',
      ],
    },
    {
      'Section': 'Integrated Civics: Geography',
      'Number': 93,
      'Question': 'Name one state that borders Mexico.',
      'Answer': [
        'California',
        'Arizona',
        'New Mexico',
        'Texas',
      ],
    },
    {
      'Section': 'Integrated Civics: Geography',
      'Number': 94,
      'Question': 'What is the capital of the United States?*',
      'Answer': ['Washington, D.C.'],
    },
    {
      'Section': 'Integrated Civics: Geography',
      'Number': 95,
      'Question': 'Where is the Statue of Liberty?*',
      'Answer': [
        'New York (Harbor)',
        'Liberty Island',
        'New Jersey',
        'near New York City',
        'on the Hudson (River)',
      ],
    },
    {
      'Section': 'Integrated Civics: Symbols',
      'Number': 96,
      'Question': 'Why does the flag have 13 stripes?',
      'Answer': [
        'because there were 13 original colonies',
        'because the stripes represent the original colonies',
      ],
    },
    {
      'Section': 'Integrated Civics: Symbols',
      'Number': 97,
      'Question': 'Why does the flag have 50 stars?*',
      'Answer': [
        'because there is one star for each state',
        'because each star represents a state',
        'because there are 50 states',
      ],
    },
    {
      'Section': 'Integrated Civics: Symbols',
      'Number': 98,
      'Question': 'What is the name of the national anthem?',
      'Answer': ['The Star-Spangled Banner'],
    },
    {
      'Section': 'Integrated Civics: Holidays',
      'Number': 99,
      'Question': 'When do we celebrate Independence Day?*',
      'Answer': ['July 4'],
    },
    {
      'Section': 'Integrated Civics: Holidays',
      'Number': 100,
      'Question': 'Name two national U.S. holidays.',
      'Answer': [
        'New Year’s Day',
        'Martin Luther King, Jr. Day',
        'Presidents’ Day',
        'Memorial Day',
        'Independence Day',
        'Labor Day',
        'Columbus Day',
        'Veterans Day',
        'Thanksgiving',
        'Christmas',
      ],
    }
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Civics Questions and Answers'),
          backgroundColor: Colors.blue,
        ),
        body: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            final question = questions[index]['Question'];
            final answers = questions[index]['Answer'];

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Q${index + 1}: $question',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A: ${answers.join(", ")}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
}
