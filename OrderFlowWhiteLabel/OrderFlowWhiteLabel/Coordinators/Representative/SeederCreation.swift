import FirebaseAuth
import FirebaseFirestore

class Seeder {
    
    static func createMissingRepresentatives() async {
        // Apenas os 2 que faltaram
        let users = [
            (name: "Gabriel Ribeiro", email: "g.ribeiro@admin.com"),
            (name: "Gabriel Eduardo", email: "g.eduardo@admin.com"),
            (name: "Joao Maminha",    email: "j.maminha@admin.com")
            
        ]
        
        let password = "123456"
        
        for user in users {
            do {
                // 1. Cria e ESPERA terminar (await)
                let _ = try await Auth.auth().createUser(withEmail: user.email, password: password)
           
                
                // 2. Salva no banco e ESPERA terminar
                let data: [String: Any] = [
                    "name": user.name,
                    "email": user.email,
                    "role": "representative",
                    "created_at": FieldValue.serverTimestamp()
                ]
                
                try await Firestore.firestore().collection("representative").document(user.email).setData(data)
                
                print("✅ SUCESSO! [\(user.name)")
                
                try Auth.auth().signOut()
                
            } catch {
                print("❌ ERRO ao criar \(user.name): \(error.localizedDescription)")
            }
        }
    }
}
