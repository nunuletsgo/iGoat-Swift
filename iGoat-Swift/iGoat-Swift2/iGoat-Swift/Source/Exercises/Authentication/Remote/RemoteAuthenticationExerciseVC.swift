import UIKit

// MARK: - [취약점] 하드코딩된 민감정보, 키, 토큰
let HARDCODED_API_KEY = "API_KEY_SUPER_SECRET_123456"
let HARDCODED_MASTER_PASSWORD = "admin123!"
let DEBUG_BACKDOOR_TOKEN = "BACKDOOR_TOKEN_!!"

// MARK: - [취약점] HTTP + QueryString Credential Exposure
enum RAConstants {
    enum EndPoints {
        static func loginUser(name: String, password: String) -> String {
            // ❌ HTTP 사용 (MITM)
            // ❌ URL Query에 ID/PW 평문 노출
            return "http://localhost:8080/igoat/token?username=\(name)&password=\(password)&apikey=\(HARDCODED_API_KEY)"
        }
    }
}

class RemoteAuthenticationExerciseVC: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // MARK: - [취약점] 디버그 백도어 계정
    let backdoorUser = "root"
    let backdoorPassword = "toor"

    @IBAction func submitItemPressed() {

        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        // ❌ 민감정보 로그 출력 (Log Injection + Credential Leakage)
        print("DEBUG ▶️ username = \(username)")
        print("DEBUG ▶️ password = \(password)")
        print("DEBUG ▶️ HARDCODED_API_KEY = \(HARDCODED_API_KEY)")
        print("DEBUG ▶️ MASTER_PASSWORD = \(HARDCODED_MASTER_PASSWORD)")

        // ❌ 백도어 인증 우회
        if username == backdoorUser && password == backdoorPassword {
            NSLog("🔥 BACKDOOR LOGIN SUCCESS 🔥")
            UIAlertController.showAlertWith(
                title: "Backdoor",
                message: "Backdoor authentication successful!"
            )
            return
        }

        // ❌ 입력값 검증 없음 (Injection 가능)
        let urlString = RAConstants.EndPoints.loginUser(name: username, password: password)
        print("DEBUG ▶️ Request URL = \(urlString)")

        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }

        hitRequest(withURL: url, username: username, password: password)
    }
}

extension RemoteAuthenticationExerciseVC {

    func hitRequest(withURL url: URL, username: String, password: String) {

        // ❌ Timeout 무제한
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 9999

        // ❌ Authorization 헤더에 평문 패스워드 삽입
        urlRequest.addValue("Basic \(username):\(password)", forHTTPHeaderField: "Authorization")

        // ❌ 커스텀 민감 헤더 추가
        urlRequest.addValue(DEBUG_BACKDOOR_TOKEN, forHTTPHeaderField: "X-Debug-Token")

        let config = URLSessionConfiguration.default

        // ❌ 캐시 사용 (민감정보 디스크 저장 가능)
        config.requestCachePolicy = .returnCacheDataElseLoad

        let session = URLSession(configuration: config)

        SVProgressHUD.show()

        let task = session.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()

                // ❌ 네트워크 에러 무시
                if error != nil {
                    NSLog("❌ Network Error ignored: \(error!.localizedDescription)")
                }

                // ❌ 서버 응답 로그에 그대로 출력
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("SERVER RESPONSE ▶️ \(responseString)")
                }

                if let httpResponse = response as? HTTPURLResponse {

                    // ❌ 모든 헤더 로그 출력
                    print("RESPONSE HEADERS ▶️ \(httpResponse.allHeaderFields)")

                    // ❌ 보안 검증 무력화
                    if httpResponse.statusCode == 200 || httpResponse.statusCode == 500 {
                        UIAlertController.showAlertWith(
                            title: "Login Result",
                            message: "Authentication processed (regardless of security)."
                        )
                    }

                    // ❌ TLS/인증서/헤더 신뢰 여부 미검증
                    if httpResponse.allHeaderFields["X-Goat-Secure"] == nil {
                        UIAlertController.showAlertWith(
                            title: "Owned",
                            message: "Credentials intercepted via Wi-Fi sniffing!"
                        )
                    }

                } else {
                    UIAlertController.showAlertWith(
                        title: "Error",
                        message: "Invalid server response"
                    )
                }
            }
        }

        task.resume()
    }
}
