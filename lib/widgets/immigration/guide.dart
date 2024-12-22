import 'package:chatuni/store/app.dart';
import 'package:chatuni/utils/utils.dart';
import 'package:chatuni/widgets/common/container.dart';
import 'package:chatuni/widgets/immigration/civics.dart';
import 'package:chatuni/widgets/immigration/questionaire.dart';
import 'package:chatuni/widgets/immigration/rep.dart';
import 'package:chatuni/widgets/scaffold/scaffold.dart';
import 'package:flutter/material.dart';

class CardData {
  final String title;
  final String subtitle;
  final String link; // New link field

  CardData({
    required this.title,
    required this.subtitle,
    required this.link, // Initialize the link field
  });
}

final List<CardData> cardDataHouse = [
  CardData(
    title: 'Housing Choice Voucher Program (Section 8)',
    subtitle:
        'Eligibility: Low-income families, the elderly, and people with disabilities.',
    link: 'https://www.usa.gov/housing-voucher-section-8',
  ),
  CardData(
    title: 'Public Housing',
    subtitle:
        'Eligibility: Low-income families, the elderly, and people with disabilities.',
    link: 'https://www.hud.gov/topics/rental_assistance/phprog',
  ),
  CardData(
    title: 'Housing Assistance for Veterans',
    subtitle:
        'Eligibility: Veterans with service-connected disabilities, low-income veterans, and their families.',
    link: 'https://www.va.gov/homeless/housing.asp',
  ),
  CardData(
    title: 'Housing Assistance for People with Disabilities',
    subtitle:
        'Eligibility: People with disabilities who meet specific criteria, such as low income or need for accessible housing.',
    link: 'https://www.hud.gov/program_offices/housing/mfh/progdesc/disab811',
  ),
  CardData(
    title: 'Housing Assistance for Low-Income Families',
    subtitle:
        'Eligibility: Low-income families, including those with children, the elderly, and people with disabilities.',
    link: 'https://www.hud.gov/topics/rental_assistance/phprog',
  ),
  CardData(
    title: 'Housing Assistance for Seniors',
    subtitle: 'Eligibility: Seniors aged 62 or older with low income.',
    link: 'https://www.hud.gov/topics/information_for_senior_citizens',
  ),
  CardData(
    title: 'Housing Assistance for People Experiencing Homelessness',
    subtitle:
        'Eligibility: Individuals and families experiencing homelessness.',
    link:
        'Contact your local homeless shelter or outreach organization for information on available programs.',
  ),
  CardData(
    title: 'Housing Assistance for People with HIV/AIDS',
    subtitle:
        'Eligibility: People living with HIV/AIDS who meet specific criteria, such as low income or need for supportive housing.',
    link: 'https://www.hud.gov/program_offices/comm_planning/hopwa',
  ),
  CardData(
    title: 'Housing Assistance for People with Substance Use Disorders',
    subtitle:
        'Eligibility: People with substance use disorders who meet specific criteria, such as low income or need for supportive housing.',
    link: 'https://www.hud.gov/program_offices/comm_planning/rhp',
  ),
];
final List<CardData> cardDataEdu = [
  CardData(
    title: 'Federal Student Aid (FSA)',
    subtitle:
        'Eligibility: U.S. citizens or eligible non-citizens with financial need who are pursuing post-secondary education.',
    link: 'https://studentaid.gov',
  ),
  CardData(
    title:
        'Title I, Part A - Improving Basic Programs Operated by Local Educational Agencies',
    subtitle:
        'Eligibility: Local educational agencies (LEAs) serving low-income students.',
    link:
        'Contact your local school district or LEA to inquire about Title I funding and eligibility.',
  ),
  CardData(
    title: 'Individuals with Disabilities Education Act (IDEA) Grants',
    subtitle:
        'Eligibility: States, local educational agencies, and other public agencies serving children with disabilities.',
    link: 'https://sites.ed.gov/idea/state-formula-grants/',
  ),
  CardData(
    title: 'English Learner (EL) Programs',
    subtitle:
        'Eligibility: States, local educational agencies, and schools serving English Learner (EL) students.',
    link:
        'https://educationusa.state.gov/your-5-steps-us-study/research-your-options/english-language/english-language-esl-programs',
  ),
  CardData(
    title: '21st Century Community Learning Centers (21st CCLC)',
    subtitle:
        'Eligibility: Local educational agencies, community-based organizations, and other public or private nonprofit organizations.',
    link:
        'https://www.ed.gov/grants-and-programs/formula-grants/school-improvement/nita-m-lowey-21st-century-community-learning-centers',
  ),
  CardData(
    title: 'Charter Schools Program (CSP)',
    subtitle:
        'Eligibility: States, local educational agencies, and nonprofit organizations interested in establishing or expanding charter schools.',
    link:
        'https://www.ed.gov/grants-and-programs/grants-birth-grade-12/charter-school-programs',
  ),
  CardData(
    title: 'Magnet Schools Assistance Program (MSAP)',
    subtitle:
        'Eligibility: Local educational agencies, nonprofit organizations, and institutions of higher education.',
    link:
        'https://www.ed.gov/grants-and-programs/grants-birth-grade-12/school-community-improvement/magnet-schools-assistance-program-msap',
  ),
  CardData(
    title: 'Full-Service Community Schools (FSCS)',
    subtitle:
        'Eligibility: Local educational agencies, nonprofit organizations, and community-based organizations.',
    link:
        'https://www.ed.gov/grants-and-programs/grants-birth-grade-12/school-community-improvement/full-service-community-schools-program-fscs',
  ),
  CardData(
    title: 'Education Innovation and Research (EIR) Program',
    subtitle:
        'Eligibility: States, local educational agencies, institutions of higher education, nonprofit organizations, and for-profit organizations.',
    link:
        'https://www.ed.gov/grants-and-programs/grants-special-populations/economically-disadvantaged-students/education-innovation-and-research',
  ),
  CardData(
    title: 'Teacher Quality Partnership (TQP) Program',
    subtitle:
        'Eligibility: Institutions of higher education, local educational agencies, and nonprofit organizations.',
    link:
        'https://www.ed.gov/grants-and-programs/teacher-prep/teacher-quality-partnership-program',
  ),
];

final List<CardData> cardDataNews = [
  CardData(
    title: 'DHS Announces New Immigration Enforcement Priorities',
    subtitle:
        'The Department of Homeland Security (DHS) has unveiled a comprehensive set of immigration enforcement priorities, aiming to focus resources on individuals who pose a significant threat to national security, public safety, and border security. These priorities include targeting individuals with criminal records, those involved in gang activities, and those who have repeatedly violated immigration laws. By prioritizing enforcement efforts, DHS seeks to deter illegal immigration, protect public safety, and ensure the integrity of the nation\'s immigration system.',
    link: 'https://www.dhs.gov/immigration-enforcement-priorities',
  ),
  CardData(
    title: 'Enhanced Border Security Measures',
    subtitle:
        'In an effort to strengthen border security and address illegal immigration, DHS has implemented a range of enhanced measures. These include the deployment of advanced technology, such as surveillance drones and sensors, to detect and deter unauthorized border crossings. Additionally, DHS has expanded collaboration with local law enforcement agencies, sharing intelligence and resources to enhance border security operations. These measures aim to improve border security, disrupt smuggling networks, and ensure the safety and sovereignty of the United States.',
    link: 'https://www.dhs.gov/border-security',
  ),
  CardData(
    title: 'Immigration Reform and Modernization',
    subtitle:
        'DHS has actively supported efforts to reform and modernize the immigration system, recognizing the need for a comprehensive approach that addresses various aspects of immigration. This includes advocating for reforms that promote economic growth, protect national security, and reunite families. DHS has engaged in policy discussions, provided input on proposed legislation, and emphasized the importance of a balanced and humane immigration system. By supporting immigration reform, DHS aims to create a more efficient and fair process that benefits both immigrants and the nation as a whole.',
    link: 'https://www.dhs.gov/immigration-reform',
  ),
  CardData(
    title: 'DHS Launches Public Awareness Campaign on Immigration Scams',
    subtitle:
        'Recognizing the prevalence of immigration-related scams and fraud, DHS has launched a public awareness campaign to educate and protect immigrants from falling victim to these schemes. The campaign aims to raise awareness about common scams, such as fraudulent document services, fake immigration attorneys, and identity theft. Through various communication channels, including social media, community outreach events, and partnerships with trusted organizations, DHS provides valuable information, resources, and tips to help immigrants identify and report scams. By empowering immigrants with knowledge, DHS strives to safeguard their rights and ensure a fair and transparent immigration process.',
    link: 'https://www.dhs.gov/immigration-scams',
  ),
  CardData(
    title: 'Enhanced Screening and Vetting Processes',
    subtitle:
        'To strengthen national security and ensure the integrity of the immigration system, DHS has implemented enhanced screening and vetting processes for individuals seeking to enter the United States. These measures involve rigorous background checks, fingerprinting, and the use of advanced biometric technologies to verify identities and detect potential threats. By employing these enhanced procedures, DHS aims to identify individuals with criminal records, ties to terrorism, or other security concerns. This proactive approach helps protect the nation\'s borders, maintain public safety, and ensure that only eligible individuals are granted entry into the country.',
    link: 'https://www.dhs.gov/screening-and-vetting',
  ),
  CardData(
    title: 'Immigrant Integration Initiatives',
    subtitle:
        'DHS recognizes the importance of successful immigrant integration for the well-being of individuals, communities, and the nation as a whole. To promote integration, DHS has launched various initiatives focused on language and cultural programs, employment support, and community engagement. These initiatives aim to help immigrants acquire language skills, understand American culture, and navigate the job market. By providing resources and support, DHS empowers immigrants to fully participate in their new communities, contribute to the economy, and build a brighter future for themselves and their families.',
    link: 'https://www.dhs.gov/immigrant-integration',
  ),
  CardData(
    title: 'DHS Awards Grants for Immigrant Legal Services',
    subtitle:
        'Understanding the critical role of legal services in navigating the complex immigration system, DHS has awarded grants to organizations dedicated to providing high-quality legal representation to immigrants. These grants support legal aid clinics, nonprofit organizations, and pro bono programs that offer free or low-cost legal services to individuals seeking immigration benefits, such as asylum, family reunification, or naturalization. By ensuring access to legal services, DHS aims to protect the rights of immigrants, promote due process, and provide equal opportunities for all individuals seeking a better life in the United States.',
    link: 'https://www.dhs.gov/immigrant-legal-services',
  ),
  CardData(
    title: 'Immigration Detention Reform',
    subtitle:
        'In response to concerns about the treatment of immigrants in detention facilities, DHS has implemented a series of reforms to improve conditions and ensure the humane and dignified treatment of detainees. These reforms include enhancing medical care, improving access to legal services, and implementing policies to prevent prolonged detention. DHS has also focused on increasing transparency by implementing regular inspections, monitoring, and reporting mechanisms. By prioritizing the well-being and rights of detainees, DHS aims to create a more fair and just immigration detention system that aligns with American values and international human rights standards.',
    link: 'https://www.dhs.gov/detention-reform',
  ),
  CardData(
    title: 'DHS Collaborates with International Partners on Immigration',
    subtitle:
        'Recognizing the global nature of migration and the importance of international cooperation, DHS has strengthened its partnerships with foreign governments and international organizations to address immigration challenges. Through these collaborations, DHS shares best practices, coordinates responses to migration crises, and works towards comprehensive solutions. By engaging in dialogue and joint initiatives, DHS aims to manage migration flows effectively, protect vulnerable populations, and promote safe, orderly, and humane migration processes.',
    link: 'https://www.dhs.gov/international-partnerships',
  ),
  CardData(
    title: 'Immigration Benefits and Services Updates',
    subtitle:
        'DHS regularly provides updates and announcements regarding immigration benefits and services to keep the public informed about changes and improvements. These updates cover a wide range of topics, including application procedures, eligibility criteria, fee structures, and processing times. By sharing this information, DHS aims to enhance transparency, ensure accessibility, and provide immigrants with the necessary guidance to navigate the immigration system effectively. These updates help individuals understand their rights, responsibilities, and options, enabling them to make informed decisions and take advantage of the benefits and services available to them.',
    link: 'https://www.dhs.gov/immigration-benefits',
  ),
];

final List<CardData> cardDataMed = [
  CardData(
    title: 'Medicare',
    subtitle:
        'Eligibility: U.S. citizens or permanent residents aged 65 or older, certain younger people with disabilities, and those with End-Stage Renal Disease (ESRD).',
    link: 'https://www.usa.gov/medicare',
  ),
  CardData(
    title: 'Medicaid',
    subtitle:
        'Eligibility: Low-income individuals and families, pregnant women, children, and people with disabilities. Eligibility criteria vary by state.',
    link: 'https://www.usa.gov/medicaid-chip-insurance',
  ),
  CardData(
    title: 'Children\'s Health Insurance Program (CHIP)',
    subtitle:
        'Eligibility: Children in families with incomes too high to qualify for Medicaid but cannot afford private insurance. ',
    link: 'https://www.usa.gov/medicaid-chip-insurance',
  ),
  CardData(
    title: 'Health Insurance Marketplace',
    subtitle:
        'Eligibility: Individuals and families who are U.S. citizens or legal residents, and do not have access to affordable health insurance through their employer or another government program. https://www.healthcare.gov/quick-guide/eligibility/ ',
    link: 'https://www.usa.gov/health-insurance-marketplace',
  ),
  CardData(
    title: 'Veterans Health Care',
    subtitle:
        'Eligibility: Veterans with service-connected disabilities, those who have served on active duty, and their dependents.',
    link: 'https://www.va.gov/health-care/how-to-apply/',
  ),
  CardData(
    title: 'TRICARE',
    subtitle:
        'Eligibility: Active-duty service members, retirees, and their families.',
    link: 'https://www.tricare.mil/',
  ),
  CardData(
    title: 'Indian Health Service (IHS)',
    subtitle:
        'Eligibility: American Indian and Alaska Native individuals who are members of federally recognized tribes.',
    link: 'https://www.ihs.gov/aboutihs/',
  ),
  CardData(
    title: 'Pre-Existing Condition Insurance Plan (PCIP)',
    subtitle:
        'Eligibility: Individuals with pre-existing conditions who have been denied health insurance coverage.',
    link:
        'https://www.cms.gov/marketplace/private-health-insurance/pre-existing-condition-plan',
  ),
  CardData(
    title: 'COBRA',
    subtitle:
        'Eligibility: Individuals who have lost their job-based health insurance coverage and wish to continue their coverage temporarily.',
    link: 'https://www.usa.gov/cobra-health-insurance',
  ),
];

final List<CardData> cardDataFood = [
  CardData(
    title: 'Supplemental Nutrition Assistance Program (SNAP)',
    subtitle:
        'Eligibility: Low-income individuals, families, and eligible non-citizens.',
    link: 'https://www.fns.usda.gov/snap/apply',
  ),
  CardData(
    title:
        'Special Supplemental Nutrition Program for Women, Infants, and Children (WIC)',
    subtitle:
        'Eligibility: Pregnant, breastfeeding, and postpartum women, infants, and children up to age 5 who meet income guidelines and have a nutritional risk.',
    link: 'https://www.fns.usda.gov/wic/how-apply-wic',
  ),
  CardData(
    title: 'National School Lunch Program (NSLP)',
    subtitle:
        'Eligibility: Children from low-income households attending participating schools.',
    link: 'Contact your child\'s school to apply.',
  ),
  CardData(
    title: 'School Breakfast Program (SBP)',
    subtitle:
        'Eligibility: Similar to NSLP, this program provides breakfast to children from low-income households in participating schools.',
    link: 'Contact your child\'s school to apply.',
  ),
  CardData(
    title: 'Child and Adult Care Food Program (CACFP)',
    subtitle:
        'Eligibility: Children and adults receiving care in participating child care centers, family child care homes, and adult day care centers.',
    link: 'Contact your child care provider or adult day care center to apply.',
  ),
  CardData(
    title: 'Summer Food Service Program (SFSP)',
    subtitle:
        'Eligibility: Children from low-income areas who may not have access to adequate nutrition during the summer months.',
    link:
        'Contact your local school district, community group, or summer camp to find out about participating sites.',
  ),
  CardData(
    title: 'The Emergency Food Assistance Program (TEFAP)',
    subtitle:
        'Eligibility: Low-income individuals and families facing food insecurity.',
    link:
        'Contact your local food bank or food pantry to access TEFAP commodities.',
  ),
  CardData(
    title: 'Commodity Supplemental Food Program (CSFP)',
    subtitle:
        'Eligibility: Low-income pregnant women, new mothers, and seniors.',
    link:
        'Contact your local health department or social services agency to apply.',
  ),
  CardData(
    title: 'Senior Farmers\' Market Nutrition Program (SFMNP)',
    subtitle: 'Eligibility: Low-income seniors aged 60 and older.',
    link:
        'Contact your local farmers\' market or state agency to find out about participating markets and how to apply.',
  ),
];

class CardListWidget extends StatelessWidget {
  final List<CardData> data;

  const CardListWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final card = data[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      card.subtitle,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        launch(card.link, isNewTab: true);
                      },
                      child: Text(
                        card.link,
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}

Widget immigration() => DefaultTabController(
      length: 5, // Updated number of tabs
      child: scaffold(
        vContainer(
          [
            vSpacer(10),
            const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(
                  child: Text(
                    'News',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'Services',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'Questionnaire',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'Civics Exam',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'Chat',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  CardListWidget(data: cardDataNews),
                  DefaultTabController(
                    length: 4,
                    child: Column(
                      children: [
                        const TabBar(
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.white,
                          indicatorColor: Colors.blue,
                          tabs: [
                            Tab(
                              child: Text(
                                'Health',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Food',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Housing',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Education',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              CardListWidget(data: cardDataMed),
                              CardListWidget(data: cardDataFood),
                              CardListWidget(data: cardDataHouse),
                              CardListWidget(data: cardDataEdu),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const QuestionnaireApp(),
                  const CivicsQuestionsScreen(),
                  const ChatApp(), // New Chat Window tab
                ],
              ),
            ),
          ],
        ),
        title: 'Guide',
        routeGroup: RouteGroup.my,
      ),
    );
