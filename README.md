# 담배 재고 관리 앱 (CigaretteCounter)

SwiftUI를 사용하여 제작된 고급 담배 재고 관리 iOS 앱입니다. 외부 바코드 스캐너와의 효율적인 연동을 통해 직관적인 재고 관리 워크플로우를 제공합니다.

## 주요 기능

### 1. 재고 관리
- **매대 수량**: 진열된 담배의 수량
- **창고 수량**: 창고에 보관된 담배의 수량
- **전산 재고**: POS 시스템의 재고 수량
- **차이 계산**: 전산 재고 - 창고 수량 - 매대 수량의 자동 계산

### 2. 바코드 스캔 워크플로우
1. 담배 항목 옆의 "바코드 보기" 버튼 클릭
2. 바코드 이미지가 팝업으로 표시
3. 외부 스캐너로 바코드 스캔하여 POS 수량 확인
4. 바코드 이미지를 탭하여 전산 재고 입력창으로 자동 이동
5. 숫자 키패드로 재고 입력

### 3. 사용자 경험
- 숫자 키패드 및 완료 버튼 제공
- 차이 값의 색상 코딩 (녹색: 일치, 파란색: 여유, 빨간색: 부족)
- 전체 재고 초기화 기능
- 직관적인 포커스 이동

## 설치 및 설정

### 바코드 이미지 추가
앱을 정상적으로 사용하려면 각 담배의 실제 바코드 이미지를 추가해야 합니다.

1. 다음 디렉토리에 바코드 이미지를 추가하세요:
   - `CigaretteCounter/Assets.xcassets/esse_change.imageset/esse_change_barcode.png`
   - `CigaretteCounter/Assets.xcassets/marlboro_gold.imageset/marlboro_gold_barcode.png`
   - `CigaretteCounter/Assets.xcassets/dunhill_6mg.imageset/dunhill_6mg_barcode.png`

2. 이미지 규격:
   - 형식: PNG
   - 권장 크기: 400x200 픽셀
   - 배경: 흰색
   - 바코드: 검은색

### 추가 담배 항목
새로운 담배를 추가하려면:

1. `InventoryViewModel.swift`의 `cigarettes` 배열에 새 항목 추가
2. Assets.xcassets에 해당 바코드 이미지 추가

예시:
```swift
Cigarette(name: "새로운 담배", barcodeImageName: "new_cigarette")
```

## 프로젝트 구조

```
CigaretteCounter/
├── Cigarette.swift              # 데이터 모델
├── InventoryViewModel.swift     # 뷰 모델
├── ContentView.swift           # 메인 화면
├── BarcodeDisplayView.swift    # 바코드 표시 화면
├── CigaretteCounterApp.swift   # 앱 진입점
└── Assets.xcassets/            # 이미지 리소스
    ├── esse_change.imageset/
    ├── marlboro_gold.imageset/
    └── dunhill_6mg.imageset/
```

## 요구사항

- iOS 15.0 이상
- Xcode 13.0 이상
- SwiftUI 3.0 이상

## 사용법

1. Xcode에서 프로젝트 열기
2. 실제 바코드 이미지를 Assets.xcassets에 추가
3. iOS 디바이스 또는 시뮬레이터에서 실행
4. 각 담배의 재고 수량 입력
5. 바코드 보기 버튼으로 바코드 스캔 및 전산 재고 입력

## 라이선스

이 프로젝트는 개인 사용을 위한 예제 앱입니다. 