<div align="center">

<img src="docs/icon.png" width="128" height="128" alt="Softfold" />

# Softfold

**Gập màn hình lại, bàn làm việc sẽ nhẹ nhàng xếp lại.**

<a href="https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/readme/download-en-dark.png">
    <img src="docs/readme/download-en-light.png" height="52" alt="Tải Softfold cho Mac">
  </picture>
</a>

<p>
  <a href="https://trendshift.io/repositories/237288?utm_source=trendshift-badge&amp;utm_medium=badge&amp;utm_campaign=badge-trendshift-237288" target="_blank" rel="noopener noreferrer"><img src="https://trendshift.io/api/badge/trendshift/repositories/237288/daily?language=Swift" alt="ReffWu%2Fsoftfold | Trendshift" width="250" height="55"/></a>
</p>

<sub>Miễn phí · MacBook với Apple Silicon · macOS 14 trở lên · Đã được Apple công chứng</sub>

<sub>Nếu bạn yêu thích Softfold, một ⭐ trên GitHub sẽ giúp nhiều người biết đến ứng dụng hơn.</sub>

[English](README.md) · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [Deutsch](README.de.md) · [Français](README.fr.md) · [Español](README.es.md) · [Italiano](README.it.md) · [Português](README.pt-BR.md) · [Русский](README.ru.md) · [Nederlands](README.nl.md) · [Türkçe](README.tr.md) · [Polski](README.pl.md) · [العربية](README.ar.md) · Tiếng Việt · [🌍 Tất cả 39 ngôn ngữ](docs/locales/README.md)

</div>

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/readme/hero-en-dark.webp">
    <img src="docs/readme/hero-en-light.webp" alt="Gập màn hình lại, bàn làm việc sẽ nhẹ nhàng xếp lại.">
  </picture>
</p>

---

Softfold chuyển động nhịp nhàng theo bản lề MacBook của bạn. Khi bạn hạ màn hình xuống, bàn làm việc trực tiếp cũng nghiêng dần ra sau, mờ dần từ trên xuống dưới và hòa vào các cạnh tối. Khi nâng màn hình lên, mọi thứ trở lại sắc nét và nguyên vẹn ngay tại vị trí bạn đã rời đi.

## Tải về

[Tải xuống Softfold.dmg](https://github.com/ReffWu/softfold/releases/latest/download/Softfold.dmg), mở tệp và kéo Softfold vào thư mục Ứng dụng (Applications). Ứng dụng được ký bằng Developer ID và đã được Apple công chứng, mở lên an toàn như mọi ứng dụng Mac bản địa khác.

Trong lần khởi chạy đầu tiên, hãy cấp quyền «Ghi màn hình» trong Cài đặt hệ thống, mở lại Softfold nếu macOS yêu cầu và bật ứng dụng. Kể từ đó, Softfold sẽ tự động khởi động cùng máy Mac và luôn sẵn sàng hoạt động.

Lần đầu tiên bạn bật Softfold, ứng dụng sẽ lấy góc mở màn hình hiện tại làm chuẩn. Để thay đổi sau này, hãy giữ màn hình ở góc bạn thích và nhấn **Sử dụng góc hiện tại**. Phím tắt <kbd>⌃</kbd> <kbd>⌥</kbd> <kbd>H</kbd> cho phép bạn bật hoặc tắt hiệu ứng tức thì từ bất kỳ đâu.

## Các dòng MacBook tương thích

Softfold yêu cầu cảm biến góc bản lề mà Apple bắt đầu trang bị từ năm 2019 (được đọc trên Apple Silicon thông qua bộ đồng xử lý cảm biến), cùng với macOS 14 trở lên. Nếu máy Mac của bạn không có cảm biến này, Softfold sẽ thông báo ngay cho bạn.

| Trạng thái | Dòng máy |
| --- | --- |
| Hoạt động tốt, người dùng đã xác nhận | MacBook Pro 14 và 16 inch với M1 Pro hoặc M1 Max (2021), M2 Max (2023), M3 Pro hoặc M3 Max (2023), M4 Pro hoặc M4 Max (2024). MacBook Air với M4 (2025) hoặc M5 |
| Có cảm biến, chưa xác nhận | MacBook Pro 14 inch với M3, M4 hoặc M5. MacBook Pro 14 và 16 inch với M5 Pro hoặc M5 Max. MacBook Air với M2 hoặc M3 |
| Không hỗ trợ | MacBook Air với M1, toàn bộ MacBook Pro 13 inch (Intel, M1 và M2), MacBook Pro dùng chip Intel, MacBook 12 inch, MacBook Neo, máy Mac để bàn |

MacBook Pro 16 inch 2019 cũng có cảm biến này, nhưng bản phát hành hiện tại được xây dựng riêng cho nền tảng Apple Silicon.

Bạn không chắc chắn? Hãy chạy lệnh này trong Terminal. Dòng kết quả kết thúc bằng «las» nghĩa là Softfold có thể đọc được góc bản lề của bạn:

```sh
hidutil list --matching '{"VendorID":0x5ac,"PrimaryUsagePage":32,"PrimaryUsage":138}'
```

Bạn đã dùng thử trên một dòng máy ở hàng giữa? [Hãy chia sẻ trải nghiệm với chúng tôi](https://github.com/ReffWu/softfold/issues).

## Nguyên lý hoạt động

Softfold đọc góc mở nắp máy qua IOKit HID với độ chính xác đến một phần trăm độ, bám sát nhịp làm mới tự nhiên của cảm biến thay vì liên tục thăm dò. Bộ lọc giảm chấn tới hạn (critically damped filter) chuyển đổi các số liệu này thành chuyển động mượt mà và tự nhiên. Nghiêng chậm thì gập nhẹ nhàng. Nghiêng nhanh thì gập tức thì. Nếu bạn dừng lại nửa chừng trong một giây, màn hình bàn làm việc sẽ từ từ lấy lại độ nét, rồi tiếp tục gập lại ngay khi bạn tiếp tục khép nắp.

ScreenCaptureKit cung cấp luồng bàn làm việc trực tiếp và Metal xử lý góc nhìn 3D, độ mờ lũy tiến và vùng tối viền xung quanh ở tốc độ mượt mà 60 fps. Quá trình chụp màn hình chỉ diễn ra trong lúc nắp máy đang đóng hoặc đang gập, và dừng lại vài giây sau khi nắp mở hẳn ra, giúp tắt chỉ báo ghi màn hình màu cam của macOS. Mọi khung hình chỉ lưu tạm trong bộ nhớ RAM, tuyệt đối không bị ghi lại hay tải lên mạng. Mỗi ngày một lần, Softfold gửi một tín hiệu ẩn danh gồm ID cài đặt ngẫu nhiên, phiên bản ứng dụng và macOS, kiểu máy Mac và việc hiệu ứng có được dùng trong ngày hay không để ước tính lượng máy Mac đang hoạt động. Không có nội dung màn hình, tệp, địa chỉ IP hay dữ liệu cá nhân nào bị thu thập. Bạn có thể tắt mục «Chia sẻ thống kê sử dụng ẩn danh» trong cửa sổ Softfold bất cứ lúc nào.

Thiết kế chuyển động chi tiết có trong tài liệu [MOTION.md](MOTION.md).

## Ngôn ngữ hỗ trợ

Tiếng Anh, Tiếng Trung giản thể, Tiếng Trung phồn thể, Tiếng Nhật, Tiếng Hàn, Tiếng Đức, Tiếng Pháp, Tiếng Tây Ban Nha, Tiếng Ý, Tiếng Bồ Đào Nha Brazil, Tiếng Nga, Tiếng Hà Lan, Tiếng Thổ Nhĩ Kỳ, Tiếng Ba Lan, Tiếng Ả Rập và Tiếng Việt. Softfold tự động theo ngôn ngữ của máy Mac hoặc bạn có thể chọn thủ công trong cửa sổ ứng dụng.

## Biên dịch từ mã nguồn

Cài đặt Xcode, sau đó chạy:

```sh
git clone https://github.com/ReffWu/softfold.git
cd softfold
make build
open build/Softfold.app
```

Các bước kiểm tra trong quá trình phát triển được mô tả tại [CHECKS.md](CHECKS.md), và quy trình phát hành có chữ ký tại [RELEASE.md](RELEASE.md).

## Đóng góp

Mọi ý tưởng, báo lỗi và yêu cầu kéo (Pull Request) đều luôn được chào đón. Hãy [tạo issue](https://github.com/ReffWu/softfold/issues) hoặc gửi Pull Request.

## Ghi nhận đóng góp

Softfold khởi đầu là một bản phân nhánh (fork) từ [Hinge](https://github.com/Noveum/hinge) của Noveum.ai, phát hành theo giấy phép MIT. Mã nhận dạng HID và định dạng báo cáo của cảm biến góc bản lề được tài liệu hóa lần đầu bởi [LidAngleSensor](https://github.com/samhenrigold/LidAngleSensor).

## Giấy phép

[MIT](LICENSE)
