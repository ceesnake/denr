import SwiftUI

struct ContentView: View {
    @State private var moveLogoUp = false
    @State private var showAdditionalContent = false
    @State private var fadeInText = false
    @State private var fadeInButtons = false

    var body: some View {
        NavigationView {
            ZStack {
                Image("backgroundBlackXcode")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Image("blackLogoXcode2")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 20)
                        .offset(y: moveLogoUp ? 0 : 0)
                        .animation(.easeInOut(duration: 1.5), value: moveLogoUp)

                    if showAdditionalContent {
                        Image("textBlackNew")
                            .resizable()
                            .scaledToFit()
                            .opacity(fadeInText ? 1 : 0)
                            .animation(.easeInOut(duration: 2), value: fadeInText)
                    }

                    if showAdditionalContent {
                        HStack(spacing: 70) {
                            NavigationLink(destination: WaitlistView()) {
                                Text("Waitlist")
                                    .padding(5)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(12)
                                    .shadow(radius: 4)
                                    .font(.footnote)
                            }
                            NavigationLink(destination: LearnMoreView()) {
                                Text("Learn More")
                                    .padding(5)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(12)
                                    .shadow(radius: 4)
                                    .font(.footnote)
                            }
                        }
                        .opacity(fadeInButtons ? 1 : 0)
                        .animation(.easeInOut(duration: 4), value: fadeInButtons)
                    }

                    Spacer()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    moveLogoUp = true
                    showAdditionalContent = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        fadeInText = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        fadeInButtons = true
                    }
                }
            }
        }
    }
}

struct WaitlistView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var street: String = ""
    @State private var apartment: String = ""
    @State private var city: String = ""
    @State private var selectedState: String = "Virginia"
    @State private var zipCode: String = ""
    @State private var selectedCountry: String = "USA"
    @State private var phone: String = ""
    @State private var email: String = ""
    @State private var birthday: Date = Date()
    @State private var facebookURL: String = ""
    @State private var craigslistURL: String = ""
    @State private var offerupURL: String = ""
    @State private var marketplaceExperience: String = ""
    @State private var agreeToTerms: Bool = false
    @State private var submitted: Bool = false
    @State private var attachmentURL: URL?
    @State private var showFileImporter: Bool = false

    let states = [
        "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware",
        "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky",
        "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi",
        "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico",
        "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
        "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont",
        "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"
    ]
    let countries = ["USA", "Canada", "Mexico"]

    var body: some View {
        ZStack {
            Image("backgroundBlackXcode")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Form {
                    Section(header: Text("Join the Waitlist").font(.headline)) {
                        TextField("First Name", text: $firstName)
                            .textContentType(.givenName)
                        TextField("Last Name", text: $lastName)
                            .textContentType(.familyName)
                        TextField("Street", text: $street)
                            .textContentType(.streetAddressLine1)
                        TextField("Apartment or Suite", text: $apartment)
                            .textContentType(.streetAddressLine2)
                        TextField("Town or City", text: $city)
                            .textContentType(.addressCity)
                        
                        Picker("State", selection: $selectedState) {
                            ForEach(states, id: \.self) { state in
                                Text(state)
                                    .foregroundColor(state == "Virginia" ? .primary : .gray)
                                    .tag(state)
                                    .disabled(state != "Virginia")
                            }
                        }
                        
                        TextField("Zip Code", text: $zipCode)
                            .keyboardType(.numberPad)
                            .textContentType(.postalCode)
                        
                        Picker("Country", selection: $selectedCountry) {
                            ForEach(countries, id: \.self) { country in
                                Text(country)
                                    .foregroundColor(country == "USA" ? .primary : .gray)
                                    .tag(country)
                                    .disabled(country != "USA")
                            }
                        }
                        
                        TextField("Phone", text: $phone)
                            .keyboardType(.phonePad)
                            .textContentType(.telephoneNumber)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
                            .environment(\.locale, Locale(identifier: "en_US"))
                        TextField("Facebook Marketplace Profile URL", text: $facebookURL)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                        TextField("Craigslist Profile URL", text: $craigslistURL)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                        TextField("OfferUp Profile URL", text: $offerupURL)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                        TextField("Community Marketplace Experience", text: $marketplaceExperience)
                    }
                    
                    Section {
                        Button(action: {
                            showFileImporter = true
                        }) {
                            HStack {
                                Text("Attachments (PDFs only)")
                                Spacer()
                                if let url = attachmentURL {
                                    Text(url.lastPathComponent)
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        .fileImporter(
                            isPresented: $showFileImporter,
                            allowedContentTypes: [.pdf],
                            allowsMultipleSelection: false
                        ) { result in
                            switch result {
                            case .success(let urls):
                                attachmentURL = urls.first
                            case .failure:
                                break
                            }
                        }
                    }

                    Section {
                        Toggle(isOn: $agreeToTerms) {
                            Text("I agree to the Terms & Conditions")
                        }
                    }
                    Section {
                        Button(action: {
                            submitToZapier()
                            submitted = true
                        }) {
                            Text("Join Waitlist")
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(!formIsValid)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .cornerRadius(16)
                .padding()
                Spacer()
            }
            .alert(isPresented: $submitted) {
                Alert(
                    title: Text("Thanks!"),
                    message: Text("You’ve joined the waitlist. We'll have more news to share soon!"),
                    dismissButton: .default(Text("OK")) {
                        submitted = false
                    }
                )
            }
        }
    }

    var formIsValid: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !street.isEmpty &&
        !city.isEmpty &&
        selectedState == "Virginia" &&
        !zipCode.isEmpty &&
        selectedCountry == "USA" &&
        !phone.isEmpty &&
        !email.isEmpty &&
        agreeToTerms
    }
    func submitToZapier() {
        guard let url = URL(string: "https://hooks.zapier.com/hooks/catch/23152025/2vu27xi/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "street": street,
            "apartment": apartment,
            "city": city,
            "state": selectedState,
            "zipCode": zipCode,
            "country": selectedCountry,
            "phone": phone,
            "email": email,
            "birthday": ISO8601DateFormatter().string(from: birthday),
            "facebookURL": facebookURL,
            "craigslistURL": craigslistURL,
            "offerupURL": offerupURL,
            "marketplaceExperience": marketplaceExperience
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, error in

        }.resume()
    }
}


struct LearnMoreView: View {
    var body: some View {
        ZStack {
            Image("backgroundBlackXcode")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView {
                    VStack(spacing: 18) {
                        Image("denIconXcode")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 95)
                        Image("denText2r")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 40)
                        Image("sacksIconXcode")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 125)
                        Image("sackText")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 40)
                        Image("CashMoneyXCode")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 125)
                        Image("cashText")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 40)
                        Image("LevelUpXCode")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 125)
                        Image("levelUpText")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 40)
                        Image("MapsXCode")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 125)
                        Image("mapsText")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 40)
                    }
                }

                Spacer()
                NavigationLink(destination: WaitlistView()) {
                    Text("Waitlist")
                        .padding(5)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                        .font(.footnote)
                }
                .padding(.bottom, 20)
            }
            .navigationBarTitle("Denr Features", displayMode: .inline)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


