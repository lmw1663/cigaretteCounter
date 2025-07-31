//
//  InventoryViewModel.swift
//  CigaretteCounter
//
//  Created by leeminwoo on 7/24/25.
//

import Foundation

class InventoryViewModel: ObservableObject {
    @Published var cigarettes: [Cigarette] = []
    @Published var selectedCigarette: Cigarette?
    @Published var searchText: String = ""
    @Published var showingNewCigaretteSheet = false
    @Published var showingEditCigaretteSheet = false
    @Published var editingCigarette: Cigarette?
    
    // 검색 결과 필터링
    var filteredCigarettes: [Cigarette] {
        if searchText.isEmpty {
            return cigarettes.sorted { $0.order < $1.order }
        } else {
            return cigarettes
                .filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                .sorted { $0.order < $1.order }
        }
    }
    
    init() {
        initializeCigarettes()
    }
    
    private func initializeCigarettes() {
        cigarettes = [
            Cigarette(name: "말보루 화이트", barcodeImageName: "product_001", order: 1, barcodeNumber: "88024615"),
            Cigarette(name: "말보루 비스타블라썸", barcodeImageName: "product_002", order: 2, barcodeNumber: "88023489"),
            Cigarette(name: "말보루 실버", barcodeImageName: "product_003", order: 3, barcodeNumber: "88012407"),
            Cigarette(name: "말보루 골드", barcodeImageName: "product_004", order: 4, barcodeNumber: "88011745"),
            Cigarette(name: "말보루 미디엄", barcodeImageName: "product_005", order: 5, barcodeNumber: "88011721"),
            Cigarette(name: "말보루 레드", barcodeImageName: "product_006", order: 6, barcodeNumber: "88011707"),
            Cigarette(name: "말보루 포레스트미스트", barcodeImageName: "product_007", order: 7, barcodeNumber: "88023441"),
            Cigarette(name: "말보루 가든 스플래시", barcodeImageName: "product_008", order: 8, barcodeNumber: "88024608"),
            Cigarette(name: "말보루 비스타 썸머", barcodeImageName: "product_009", order: 9, barcodeNumber: "88023465"),
            Cigarette(name: "말보루 비스타", barcodeImageName: "product_010", order: 10, barcodeNumber: "88023403"),
            Cigarette(name: "말보루 하이브리드 1", barcodeImageName: "product_011", order: 11, barcodeNumber: "88017648"),
            Cigarette(name: "말보루 하이브리드 5", barcodeImageName: "product_012", order: 12, barcodeNumber: "88017655"),
            Cigarette(name: "말보루 아이스블라스트", barcodeImageName: "product_013", order: 13, barcodeNumber: "88017174"),
            Cigarette(name: "말보루 아이스블라스트 1", barcodeImageName: "product_014", order: 14, barcodeNumber: "88017617"),
            Cigarette(name: "말보루 화이트후레시", barcodeImageName: "product_015", order: 15, barcodeNumber: "88011752"),
            Cigarette(name: "말보루 블랙 후래시", barcodeImageName: "product_016", order: 16, barcodeNumber: "88014494"),
            Cigarette(name: "말보루 비스타 트로피컬", barcodeImageName: "product_017", order: 17, barcodeNumber: "88023434"),
            Cigarette(name: "팔리아멘트 아쿠아 1", barcodeImageName: "product_018", order: 18, barcodeNumber: "88013114"),
            Cigarette(name: "팔리아멘트 아쿠아 3", barcodeImageName: "product_019", order: 19, barcodeNumber: "88014463"),
            Cigarette(name: "팔리아멘트 아쿠아 5", barcodeImageName: "product_020", order: 20, barcodeNumber: "88013121"),
            Cigarette(name: "팔리아멘트 하이브리드 1", barcodeImageName: "product_021", order: 21, barcodeNumber: "88017693"),
            Cigarette(name: "팔리아멘트 하이브리드 5", barcodeImageName: "product_022", order: 22, barcodeNumber: "88017624"),
            Cigarette(name: "팔리아멘트 수퍼슬림 레드", barcodeImageName: "product_023", order: 23, barcodeNumber: "88019918"),
            Cigarette(name: "버지니아 블루", barcodeImageName: "product_024", order: 24, barcodeNumber: "88011882"),
            Cigarette(name: "버지니아 골드", barcodeImageName: "product_025", order: 25, barcodeNumber: "88011851"),
            Cigarette(name: "하모니", barcodeImageName: "product_026", order: 26, barcodeNumber: "88011844"),
            Cigarette(name: "테리아 블랙루비", barcodeImageName: "product_027", order: 27, barcodeNumber: "88024189"),
            Cigarette(name: "테리아 블랙옐로우", barcodeImageName: "product_028", order: 28, barcodeNumber: "88023595"),
            Cigarette(name: "테리아 블랙퍼플", barcodeImageName: "product_029", order: 29, barcodeNumber: "88023526"),
            Cigarette(name: "테리아 퍼플웨이브", barcodeImageName: "product_030", order: 30, barcodeNumber: "88021492"),
            Cigarette(name: "테리아 썸머웨이브", barcodeImageName: "product_031", order: 31, barcodeNumber: "88023564"),
            Cigarette(name: "테리아 유젠", barcodeImageName: "product_032", order: 32, barcodeNumber: "88023090"),
            Cigarette(name: "테리아 썬펄", barcodeImageName: "product_033", order: 33, barcodeNumber: "88024141"),
            Cigarette(name: "테리아 오아시스 펄", barcodeImageName: "product_034", order: 34, barcodeNumber: "88024134"),
            Cigarette(name: "테리아 트와일라잇 펄", barcodeImageName: "product_035", order: 35, barcodeNumber: "88024752"),
            Cigarette(name: "센티아 실버", barcodeImageName: "product_036", order: 36, barcodeNumber: "88024721"),
            Cigarette(name: "센티아 그린", barcodeImageName: "product_037", order: 37, barcodeNumber: "88024745"),
            Cigarette(name: "센티아 골드", barcodeImageName: "product_038", order: 38, barcodeNumber: "88024714"),
            Cigarette(name: "센티아 퍼플", barcodeImageName: "product_039", order: 39, barcodeNumber: "88024738"),
            Cigarette(name: "테리아 블랙그린", barcodeImageName: "product_040", order: 40, barcodeNumber: "88023502"),
            Cigarette(name: "테리아 블루", barcodeImageName: "product_041", order: 41, barcodeNumber: "88023014"),
            Cigarette(name: "테리아 그린징", barcodeImageName: "product_042", order: 42, barcodeNumber: "88023038"),
            Cigarette(name: "테리아 그린", barcodeImageName: "product_043", order: 43, barcodeNumber: "88023021"),
            Cigarette(name: "테리아 앰버", barcodeImageName: "product_044", order: 44, barcodeNumber: "88023045"),
            Cigarette(name: "테리아 실버", barcodeImageName: "product_045", order: 45, barcodeNumber: "88023052"),
            Cigarette(name: "테리아 러셋", barcodeImageName: "product_046", order: 46, barcodeNumber: "88024165"),
            Cigarette(name: "테리아 티크", barcodeImageName: "product_047", order: 47, barcodeNumber: "88024158"),
            Cigarette(name: "테리아 아버 펄", barcodeImageName: "product_048", order: 48, barcodeNumber: "88023540"),
            Cigarette(name: "테리아 스탈링펄", barcodeImageName: "product_049", order: 49, barcodeNumber: "88024196"),
            Cigarette(name: "믹스 브린", barcodeImageName: "product_050", order: 50, barcodeNumber: "8801116048250"),
            Cigarette(name: "믹스 보나썸", barcodeImageName: "product_051", order: 51, barcodeNumber: "8801116050888"),
            Cigarette(name: "믹스 블루썸", barcodeImageName: "product_052", order: 52, barcodeNumber: "8801116037292"),
            Cigarette(name: "믹스 아이션", barcodeImageName: "product_053", order: 53, barcodeNumber: "8801116029914"),
            Cigarette(name: "믹스 믹스", barcodeImageName: "product_054", order: 54, barcodeNumber: "8801116012435"),
            Cigarette(name: "믹스 아이스", barcodeImageName: "product_055", order: 55, barcodeNumber: "8801116012480"),
            Cigarette(name: "믹스 프렌치", barcodeImageName: "product_056", order: 56, barcodeNumber: "8801116012595"),
            Cigarette(name: "믹스 아이스더블", barcodeImageName: "product_057", order: 57, barcodeNumber: "8801116013234"),
            Cigarette(name: "믹스 업투", barcodeImageName: "product_058", order: 58, barcodeNumber: "8801116041299"),
            Cigarette(name: "믹스 오라썸", barcodeImageName: "product_059", order: 59, barcodeNumber: "8801116042890"),
            Cigarette(name: "믹스 아이스뱅", barcodeImageName: "product_060", order: 60, barcodeNumber: "8801116015931"),
            Cigarette(name: "믹스 클래시", barcodeImageName: "product_061", order: 61, barcodeNumber: "8801116014217"),
            Cigarette(name: "믹스 콤보", barcodeImageName: "product_062", order: 62, barcodeNumber: "8801116016419"),
            Cigarette(name: "믹스 아이스모아", barcodeImageName: "product_063", order: 63, barcodeNumber: "8801116056644"),
            Cigarette(name: "핏 체인지 유니크", barcodeImageName: "product_064", order: 64, barcodeNumber: "8801116026043"),
            Cigarette(name: "핏 아이싱", barcodeImageName: "product_065", order: 65, barcodeNumber: "8801116015680"),
            Cigarette(name: "핏 체인지", barcodeImageName: "product_066", order: 66, barcodeNumber: "8801116009435"),
            Cigarette(name: "핏 체인지 업", barcodeImageName: "product_067", order: 67, barcodeNumber: "8801116009572"),
            Cigarette(name: "핏 체인지 큐", barcodeImageName: "product_068", order: 68, barcodeNumber: "8801116017232"),
            Cigarette(name: "핏 쿨 샷", barcodeImageName: "product_069", order: 69, barcodeNumber: "8801116011599"),
            Cigarette(name: "핏 스파키", barcodeImageName: "product_070", order: 70, barcodeNumber: "8801116009459"),
            Cigarette(name: "핏 아이시스트", barcodeImageName: "product_071", order: 71, barcodeNumber: "8801116018802"),
            Cigarette(name: "에임 리얼 카메오", barcodeImageName: "product_072", order: 72, barcodeNumber: "8801116031221"),
            Cigarette(name: "에임 리얼 시가리쉬", barcodeImageName: "product_073", order: 73, barcodeNumber: "8801116047000"),
            Cigarette(name: "그래뉼라 아이스러시", barcodeImageName: "product_074", order: 74, barcodeNumber: "8801116034543"),
            Cigarette(name: "에임 리얼 아이스 피크", barcodeImageName: "product_075", order: 75, barcodeNumber: "8801116047048"),
            Cigarette(name: "그래뉼라 트와이스", barcodeImageName: "product_076", order: 76, barcodeNumber: "8801116025695"),
            Cigarette(name: "그래뉼라 아이스노우", barcodeImageName: "product_077", order: 77, barcodeNumber: "8801116044443"),
            Cigarette(name: "그래뉼라 아이스", barcodeImageName: "product_078", order: 78, barcodeNumber: "8801116025671"),
            Cigarette(name: "그래뉼라 커플", barcodeImageName: "product_079", order: 79, barcodeNumber: "8801116044451"),
            Cigarette(name: "리얼 레귤러", barcodeImageName: "product_080", order: 80, barcodeNumber: "8801116025602"),
            Cigarette(name: "리얼 아이스", barcodeImageName: "product_081", order: 81, barcodeNumber: "8801116025626"),
            Cigarette(name: "에임 리얼 레귤러", barcodeImageName: "product_082", order: 82, barcodeNumber: "8801116025602"),
            Cigarette(name: "베이퍼스틱 트로피", barcodeImageName: "product_083", order: 83, barcodeNumber: "8801116048298"),
            Cigarette(name: "그래뉼라 블루밍", barcodeImageName: "product_084", order: 84, barcodeNumber: "8801116044467"),
            Cigarette(name: "베이퍼스틱 탱고", barcodeImageName: "product_085", order: 85, barcodeNumber: "8801116048311"),
            Cigarette(name: "리얼 써니스트", barcodeImageName: "product_086", order: 86, barcodeNumber: "8801116047024"),
            Cigarette(name: "그래뉼라 헤이즈", barcodeImageName: "product_087", order: 87, barcodeNumber: "8801116055050"),
            Cigarette(name: "에쎄 로열팰리스", barcodeImageName: "product_088", order: 88, barcodeNumber: "8801116007431"),
            Cigarette(name: "에쎄 골드리프", barcodeImageName: "product_089", order: 89, barcodeNumber: "8801116001392"),
            Cigarette(name: "에쎄 골드리프 1", barcodeImageName: "product_090", order: 90, barcodeNumber: "8801116005598"),
            Cigarette(name: "에쎄 골드리프 0.5", barcodeImageName: "product_091", order: 91, barcodeNumber: "8801116037377"),
            Cigarette(name: "에쎄 스페셜골드 1", barcodeImageName: "product_092", order: 92, barcodeNumber: "88011160"),
            Cigarette(name: "에쎄 스페셜골드", barcodeImageName: "product_093", order: 93, barcodeNumber: "8801116000593"),
            Cigarette(name: "에쎄 스페셜골드 0.5", barcodeImageName: "product_094", order: 94, barcodeNumber: "8801116006915"),
            Cigarette(name: "에쎄 체인지 린", barcodeImageName: "product_095", order: 95, barcodeNumber: "8801116008490"),
            Cigarette(name: "에쎄 체인지 그램", barcodeImageName: "product_096", order: 96, barcodeNumber: "8801116021888"),
            Cigarette(name: "에쎄 클래식", barcodeImageName: "product_097", order: 97, barcodeNumber: "88006642"),
            Cigarette(name: "에쎄 원", barcodeImageName: "product_098", order: 98, barcodeNumber: "88012087"),
            Cigarette(name: "에쎄 수", barcodeImageName: "product_099", order: 99, barcodeNumber: "8801116000937"),
            Cigarette(name: "에쎄 수 0.5", barcodeImageName: "product_100", order: 100, barcodeNumber: "8801116000194"),
            Cigarette(name: "에쎄 수 0.1", barcodeImageName: "product_101", order: 101, barcodeNumber: "8801116001712"),
            Cigarette(name: "에쎄 프라임", barcodeImageName: "product_102", order: 102, barcodeNumber: "88011967"),
            Cigarette(name: "에쎄 프레쏘", barcodeImageName: "product_103", order: 103, barcodeNumber: "8801116004829"),
            Cigarette(name: "에쎄 히말라야 윈터", barcodeImageName: "product_104", order: 104, barcodeNumber: "8801116042418"),
            Cigarette(name: "에쎄 아이스 1", barcodeImageName: "product_105", order: 105, barcodeNumber: "8801116003556"),
            Cigarette(name: "에쎄 이츠딥브라운", barcodeImageName: "product_106", order: 106, barcodeNumber: "8801116025251"),
            Cigarette(name: "에쎄 슈팅 레드", barcodeImageName: "product_107", order: 107, barcodeNumber: "8801116040360"),
            Cigarette(name: "에쎄 프로즌", barcodeImageName: "product_108", order: 108, barcodeNumber: "8801116015887"),
            Cigarette(name: "에쎄 히말라야", barcodeImageName: "product_109", order: 109, barcodeNumber: "8801116013319"),
            Cigarette(name: "에쎄 체인지 업", barcodeImageName: "product_110", order: 110, barcodeNumber: "8801116007257"),
            Cigarette(name: "에쎄 체인지 빙", barcodeImageName: "product_111", order: 111, barcodeNumber: "8801116010011"),
            Cigarette(name: "에쎄 체인지 w", barcodeImageName: "product_112", order: 112, barcodeNumber: "8801116006007"),
            Cigarette(name: "에쎄 체인지", barcodeImageName: "product_113", order: 113, barcodeNumber: "8801116005314"),
            Cigarette(name: "에쎄 체인지 4", barcodeImageName: "product_114", order: 114, barcodeNumber: "8801116005574"),
            Cigarette(name: "에쎄 느와르", barcodeImageName: "product_115", order: 115, barcodeNumber: "8801116051106"),
            Cigarette(name: "보헴 시가 마스터", barcodeImageName: "product_116", order: 116, barcodeNumber: "8801116002702"),
            Cigarette(name: "보헴 no 6", barcodeImageName: "product_117", order: 117, barcodeNumber: "8801116001293"),
            Cigarette(name: "보헴 no 3", barcodeImageName: "product_118", order: 118, barcodeNumber: "8801116002986"),
            Cigarette(name: "보헴 no 1", barcodeImageName: "product_119", order: 119, barcodeNumber: "8801116001279"),
            Cigarette(name: "쿠바나 더블", barcodeImageName: "product_120", order: 120, barcodeNumber: "8801116003907"),
            Cigarette(name: "쿠바나 샷", barcodeImageName: "product_121", order: 121, barcodeNumber: "8801116003921"),
            Cigarette(name: "보헴 시가리브레", barcodeImageName: "product_122", order: 122, barcodeNumber: "8801116007417"),
            Cigarette(name: "보헴 시가 미니 1", barcodeImageName: "product_123", order: 123, barcodeNumber: "8801116004652"),
            Cigarette(name: "보헴 시가 미니 5", barcodeImageName: "product_124", order: 124, barcodeNumber: "8801116004676"),
            Cigarette(name: "레종 블루", barcodeImageName: "product_125", order: 125, barcodeNumber: "88011189"),
            Cigarette(name: "레종 블랙", barcodeImageName: "product_126", order: 126, barcodeNumber: "8801116000913"),
            Cigarette(name: "레종 휘바 ice툰드라", barcodeImageName: "product_127", order: 127, barcodeNumber: "8801116043873"),
            Cigarette(name: "레종 프렌치 썸", barcodeImageName: "product_128", order: 128, barcodeNumber: "8801116024162"),
            Cigarette(name: "레종 휘바", barcodeImageName: "product_129", order: 129, barcodeNumber: "880111608131"),
            Cigarette(name: "레종 프렌치블랙", barcodeImageName: "product_130", order: 130, barcodeNumber: "8801116006830"),
            Cigarette(name: "레종 요고", barcodeImageName: "product_131", order: 131, barcodeNumber: "8801116007172"),
            Cigarette(name: "레종 아이스블랑", barcodeImageName: "product_132", order: 132, barcodeNumber: "8801116019397"),
            Cigarette(name: "에쎄 센스", barcodeImageName: "product_133", order: 133, barcodeNumber: "8801116003679"),
            Cigarette(name: "시즌", barcodeImageName: "product_134", order: 134, barcodeNumber: "88011158"),
            Cigarette(name: "아이스볼트gt", barcodeImageName: "product_135", order: 135, barcodeNumber: "8801116006731"),
            Cigarette(name: "디스플러스", barcodeImageName: "product_136", order: 136, barcodeNumber: "8801116052011"),
            Cigarette(name: "디스", barcodeImageName: "product_137", order: 137, barcodeNumber: "88006611"),
            Cigarette(name: "클라우드 9", barcodeImageName: "product_138", order: 138, barcodeNumber: "88011981"),
            Cigarette(name: "클라우드 1", barcodeImageName: "product_139", order: 139, barcodeNumber: "8801116001095"),
            Cigarette(name: "슬림핏 브라운", barcodeImageName: "product_140", order: 140, barcodeNumber: "8801116006533"),
            Cigarette(name: "시가 아이스핏", barcodeImageName: "product_141", order: 141, barcodeNumber: "8801116022731"),
            Cigarette(name: "더원 블루", barcodeImageName: "product_142", order: 142, barcodeNumber: "8801116000456"),
            Cigarette(name: "더원 오렌지", barcodeImageName: "product_143", order: 143, barcodeNumber: "8801116001033"),
            Cigarette(name: "더원 화이트", barcodeImageName: "product_144", order: 144, barcodeNumber: "8801116001613"),
            Cigarette(name: "더원 체인지", barcodeImageName: "product_145", order: 145, barcodeNumber: "8801116006076"),
            Cigarette(name: "더원 임팩트", barcodeImageName: "product_146", order: 146, barcodeNumber: "8801116002467"),
            Cigarette(name: "아프리카 아이스잭", barcodeImageName: "product_147", order: 147, barcodeNumber: "8801116008551"),
            Cigarette(name: "아프리카 몰라", barcodeImageName: "product_148", order: 148, barcodeNumber: "8801116005451"),
            Cigarette(name: "아프리카 룰라", barcodeImageName: "product_149", order: 149, barcodeNumber: "8801116006403"),
            Cigarette(name: "타임 미드", barcodeImageName: "product_150", order: 150, barcodeNumber: "88012063"),
            Cigarette(name: "에쎄 엣지", barcodeImageName: "product_151", order: 151, barcodeNumber: "8801116002003"),
            Cigarette(name: "보헴 파이브", barcodeImageName: "product_152", order: 152, barcodeNumber: "8801116010288"),
            Cigarette(name: "보헴 카리브", barcodeImageName: "product_153", order: 153, barcodeNumber: "8801116018482"),
            Cigarette(name: "심플 에이스 1", barcodeImageName: "product_154", order: 154, barcodeNumber: "8801116001965"),
            Cigarette(name: "심플 클래식", barcodeImageName: "product_155", order: 155, barcodeNumber: "88003429"),
            Cigarette(name: "라일락", barcodeImageName: "product_156", order: 156, barcodeNumber: "88003696"),
            Cigarette(name: "한라산", barcodeImageName: "product_157", order: 157, barcodeNumber: "88003542"),
            Cigarette(name: "보헴 시가 시그니처", barcodeImageName: "product_158", order: 158, barcodeNumber: "8801116040124"),
            Cigarette(name: "보헴 파이프브리튼", barcodeImageName: "product_159", order: 159, barcodeNumber: "8801116046225"),
            Cigarette(name: "이오니아 핑크", barcodeImageName: "product_160", order: 160, barcodeNumber: "8801116036028"),
            Cigarette(name: "이오니아 그린", barcodeImageName: "product_161", order: 161, barcodeNumber: "8801116036066"),
            Cigarette(name: "이오니아 퍼플", barcodeImageName: "product_162", order: 162, barcodeNumber: "8801116046522"),
            Cigarette(name: "lbs 옐로우 3", barcodeImageName: "product_163", order: 163, barcodeNumber: "88022116"),
            Cigarette(name: "lbs 옐로우 1", barcodeImageName: "product_164", order: 164, barcodeNumber: "88021331"),
            Cigarette(name: "lbs 옐로우 맥스", barcodeImageName: "product_165", order: 165, barcodeNumber: "88023229"),
            Cigarette(name: "lbs 옐로우 수퍼슬림", barcodeImageName: "product_166", order: 166, barcodeNumber: "88022123"),
            Cigarette(name: "메비우스 롱스", barcodeImageName: "product_167", order: 167, barcodeNumber: "88023243"),
            Cigarette(name: "스카이블루(곽)", barcodeImageName: "product_168", order: 168, barcodeNumber: "88020747"),
            Cigarette(name: "스카이블루(팩)", barcodeImageName: "product_169", order: 169, barcodeNumber: "88020730"),
            Cigarette(name: "lss 윈드블루", barcodeImageName: "product_170", order: 170, barcodeNumber: "88020785"),
            Cigarette(name: "lss 원", barcodeImageName: "product_171", order: 171, barcodeNumber: "88020792"),
            Cigarette(name: "lbs 아이스스톰", barcodeImageName: "product_172", order: 172, barcodeNumber: "88021386"),
            Cigarette(name: "lbs 아이스피즈", barcodeImageName: "product_173", order: 173, barcodeNumber: "88024516"),
            Cigarette(name: "lbs 시트로웨이브", barcodeImageName: "product_174", order: 174, barcodeNumber: "88024295"),
            Cigarette(name: "lbs 선셋비치", barcodeImageName: "product_175", order: 175, barcodeNumber: "88022536"),
            Cigarette(name: "e 스타일6", barcodeImageName: "product_176", order: 176, barcodeNumber: "88025254"),
            Cigarette(name: "e 스타일 3", barcodeImageName: "product_177", order: 177, barcodeNumber: "88019109"),
            Cigarette(name: "lbs 믹스그린", barcodeImageName: "product_178", order: 178, barcodeNumber: "88022147"),
            Cigarette(name: "lbs 아이스바나", barcodeImageName: "product_179", order: 179, barcodeNumber: "88024585"),
            Cigarette(name: "lbs 스파클링듀", barcodeImageName: "product_180", order: 180, barcodeNumber: "88021140"),
            Cigarette(name: "lbs 퍼플", barcodeImageName: "product_181", order: 181, barcodeNumber: "88019154"),
            Cigarette(name: "lbs 트로피컬 믹스그린", barcodeImageName: "product_182", order: 182, barcodeNumber: "88022598"),
            Cigarette(name: "lbs 오리지널", barcodeImageName: "product_183", order: 183, barcodeNumber: "88020761"),
            Cigarette(name: "lbs 윈드블루", barcodeImageName: "product_184", order: 184, barcodeNumber: "88020754"),
            Cigarette(name: "카멜 파라다이스", barcodeImageName: "product_185", order: 185, barcodeNumber: "88024592"),
            Cigarette(name: "카멜 필터 8", barcodeImageName: "product_186", order: 186, barcodeNumber: "40329055"),
            Cigarette(name: "카멜필터 5", barcodeImageName: "product_187", order: 187, barcodeNumber: "40329086"),
            Cigarette(name: "뉴욕", barcodeImageName: "product_188", order: 188, barcodeNumber: "8888075107495"),
            Cigarette(name: "파리", barcodeImageName: "product_189", order: 189, barcodeNumber: "8888075107464"),
            Cigarette(name: "런던", barcodeImageName: "product_190", order: 190, barcodeNumber: "8888075082266"),
            Cigarette(name: "던힐 6", barcodeImageName: "product_191", order: 191, barcodeNumber: "88022666"),
            Cigarette(name: "던힐 3", barcodeImageName: "product_192", order: 192, barcodeNumber: "88022673"),
            Cigarette(name: "던힐 1", barcodeImageName: "product_193", order: 193, barcodeNumber: "88022680"),
            Cigarette(name: "던힐 파인컷 1mg", barcodeImageName: "product_194", order: 194, barcodeNumber: "88014128"),
            Cigarette(name: "던힐 프로스트", barcodeImageName: "product_195", order: 195, barcodeNumber: "88022697"),
            Cigarette(name: "던힐파인컷수프림", barcodeImageName: "product_196", order: 196, barcodeNumber: "88014142"),
            Cigarette(name: "던힐파인컷캡슐스위치", barcodeImageName: "product_197", order: 197, barcodeNumber: "88020396"),
            Cigarette(name: "던힐파인컷레인보우부스트", barcodeImageName: "product_198", order: 198, barcodeNumber: "88024301"),
            Cigarette(name: "던힐파인컷멜로우크러쉬", barcodeImageName: "product_199", order: 199, barcodeNumber: "88023977"),
            Cigarette(name: "던힐파인컷트로피컬크러쉬", barcodeImageName: "product_200", order: 200, barcodeNumber: "88022727"),
            Cigarette(name: "던힐파인컷0.1", barcodeImageName: "product_201", order: 201, barcodeNumber: "88015712"),
            Cigarette(name: "던힐파인커프로스트1", barcodeImageName: "product_202", order: 202, barcodeNumber: "88016436"),
            Cigarette(name: "던힐스위치6", barcodeImageName: "product_203", order: 203, barcodeNumber: "88022949"),
            Cigarette(name: "켄트더블프레쉬", barcodeImageName: "product_204", order: 204, barcodeNumber: "88023106"),
            Cigarette(name: "켄트0.5", barcodeImageName: "product_205", order: 205, barcodeNumber: "88019482"),
            Cigarette(name: "켄트1", barcodeImageName: "product_206", order: 206, barcodeNumber: "88019475"),
            Cigarette(name: "켄트블루", barcodeImageName: "product_207", order: 207, barcodeNumber: "88019499"),
            Cigarette(name: "켄트클릭", barcodeImageName: "product_208", order: 208, barcodeNumber: "88019260"),
            Cigarette(name: "켄트퍼플", barcodeImageName: "product_209", order: 209, barcodeNumber: "88021973"),
            Cigarette(name: "켄트스위치1", barcodeImageName: "product_210", order: 210, barcodeNumber: "88021997"),
            Cigarette(name: "에쎄쿨립스", barcodeImageName: "product_211", order: 211, barcodeNumber: "8801116034192"),
            Cigarette(name: "lbs믹스그린1ss", barcodeImageName: "product_212", order: 212, barcodeNumber: "88022567")
        ]
    }
    
    func addNewCigarette(name: String, barcodeNumber: String, generatedImage: Data?) {
        let nextOrder = (cigarettes.map { $0.order }.max() ?? 0) + 1
        let imageName = "custom_\(UUID().uuidString)"
        
        let newCigarette = Cigarette(
            name: name,
            barcodeImageName: imageName,
            order: nextOrder,
            barcodeNumber: barcodeNumber
        )
        
        cigarettes.append(newCigarette)
        
        // TODO: 생성된 바코드 이미지를 Assets에 저장하는 로직 추가
        if let imageData = generatedImage {
            saveBarcodeImage(imageData: imageData, imageName: imageName)
        }
    }
    
    func editCigarette(_ cigarette: Cigarette) {
        editingCigarette = cigarette
        showingEditCigaretteSheet = true
    }
    
    func updateCigarette(id: UUID, name: String, barcodeNumber: String, generatedImage: Data?) {
        if let index = cigarettes.firstIndex(where: { $0.id == id }) {
            var updatedCigarette = cigarettes[index]
            updatedCigarette.name = name
            updatedCigarette.barcodeNumber = barcodeNumber
            
            // 바코드가 변경된 경우 새 이미지명 생성
            if cigarettes[index].barcodeNumber != barcodeNumber {
                let newImageName = "custom_\(UUID().uuidString)"
                updatedCigarette.barcodeImageName = newImageName
                
                // TODO: 새로운 바코드 이미지를 Assets에 저장
                if let imageData = generatedImage {
                    saveBarcodeImage(imageData: imageData, imageName: newImageName)
                }
            }
            
            cigarettes[index] = updatedCigarette
        }
    }
    
    func deleteCigarette(at offsets: IndexSet) {
        let sortedCigarettes = filteredCigarettes
        for index in offsets {
            if let cigaretteIndex = cigarettes.firstIndex(where: { $0.id == sortedCigarettes[index].id }) {
                cigarettes.remove(at: cigaretteIndex)
            }
        }
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        var sortedCigarettes = cigarettes.sorted { $0.order < $1.order }
        sortedCigarettes.move(fromOffsets: source, toOffset: destination)
        
        // order 재할당
        for (index, cigarette) in sortedCigarettes.enumerated() {
            if let originalIndex = cigarettes.firstIndex(where: { $0.id == cigarette.id }) {
                cigarettes[originalIndex].order = index + 1
            }
        }
    }
    
    private func saveBarcodeImage(imageData: Data, imageName: String) {
        // TODO: 실제 앱에서는 Documents 디렉토리나 다른 적절한 위치에 이미지 저장
        print("바코드 이미지 저장: \(imageName)")
    }
    
    func resetAllStocks() {
        for index in cigarettes.indices {
            cigarettes[index].storefrontStock = 0
            cigarettes[index].warehouseStock = 0
            cigarettes[index].registeredStock = 0
        }
    }
    
    func isDuplicateName(_ name: String, excludingId: UUID? = nil) -> Bool {
        return cigarettes.contains { cigarette in
            if let excludingId = excludingId, cigarette.id == excludingId {
                return false
            }
            return cigarette.name.lowercased() == name.lowercased()
        }
    }
    
    func isDuplicateBarcodeNumber(_ barcodeNumber: String, excludingId: UUID? = nil) -> Bool {
        return cigarettes.contains { cigarette in
            if let excludingId = excludingId, cigarette.id == excludingId {
                return false
            }
            return cigarette.barcodeNumber == barcodeNumber
        }
    }
} 