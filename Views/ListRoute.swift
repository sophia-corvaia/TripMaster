//
//  ListRoute.swift
//  TripMaster
//
//  Created by Sophia on 18/09/24.
//

import SwiftUI

struct ListRoute: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("logUsername") var logUsername: String = ""
    @State private var rs = RouteService()
    @State private var isPresented: Bool = false
    let category: String
    let image: String
    //@State var catRoute: [Route] = []
    @State var catRoute: [Route]
    @State private var selectedRoute: Route? // Variabile per memorizzare la route selezionata


    var body: some View {
        NavigationStack{
            VStack {
                HStack {
                    Text("Explore")
                        .padding(.horizontal)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }.padding() //HSTACK
                
                Text(category)
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .multilineTextAlignment(.center)
                    .padding()
                
                ScrollView{
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 370, height: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                    
                    ForEach($catRoute, id: \.name) { $route in
                        Button(action: {
                                selectedRoute = route // Imposta la route selezionata
                                isPresented.toggle()
                            }) {
                                HStack {
                                    Spacer()
                                    Image(route.image!)
                                        .resizable()
                                        .cornerRadius(10)
                                        .frame(width: 80, height: 80)
                                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)

                                    VStack(alignment: .leading) {
                                        Text(route.name)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(red: 21 / 255, green: 68 / 255, blue: 171 / 255))
                                            .lineLimit(nil)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        Text(route.description!)
                                            .font(.footnote)
                                            .foregroundColor(.black)
                                    }
                                    
                                    Spacer()
                                }.padding(.leading, 120)
                            }
                            .sheet(isPresented: $isPresented) {
                                if let selectedRoute = selectedRoute {
                                    // Usa .constant per non passare un Binding opzionale
                                    DetailRouteView(route: .constant(selectedRoute))
                                }
                            }
                    }
                    //FOREACH
                    .scrollContentBackground(.hidden)
                    .padding(.leading, -110)
                    .padding(.top, 10)
                }//SCROLLVIEW
            }//VSTACK
            .padding(.top, 100)
            .ignoresSafeArea(edges: .top)
            /*.onAppear{
                catRoute = rs.readRoutes(forCategory: category)
            }*/
        }//NAVIGATIONSTACK
    }//VIEW
}//VIEW

#Preview {
    ListRoute(category: "Culture", image: "teatro_massimo", catRoute: [Route(name: "A Journey Through History and Monuments", steps: [
        Step(name: "Palermo Cathedral", open_time: "08:00", closing_time: "19:00",
            description: "Start your day with a visit to Palermo Cathedral, one of the city's most iconic landmarks. Admire its extraordinary architecture that blends various styles, from Arab-Norman to Baroque.", info: "Accessibility: Partially accessible. The main area is accessible, but some sections like the royal tombs and the crypt may be challenging for people with mobility impairments.", image: "Cattedrale"),
        Step(name: "Porta Nuova", open_time: "00:00", closing_time: "24:00", description: "Continue along Corso Vittorio Emanuele towards Porta Nuova, an impressive triumphal arch marking the entrance to the historic city.", info: "Fully accessible. Free entry.", image: "porta_nuova"),
        Step(name: "Palazzo dei Normanni and Palatine Chapel", open_time: "08:30", closing_time: "16:30", description: "Explore the Palazzo dei Normanni, one of the oldest royal palaces in Europe, and the splendid Palatine Chapel, with its Byzantine mosaics.", info: "Partially accessible. Some areas of the palace are accessible, but other sections may be difficult to reach for people with mobility impairments.", image: "Cappella_palatina"),
        Step(name: "Church of San Giovanni degli Eremiti", open_time: "09:00", closing_time: "19:00", description: "Visit the Church of San Giovanni degli Eremiti, known for its distinctive red domes and tranquil cloister.", info: "Partially accessible. The church is accessible, but the cloister may present challenges for people with mobility impairments.", image: "san_giovanni"),
        Step(name: "Piazza and Fontana Pretoria", open_time: "00:00", closing_time: "24:00", description: "After visiting San Giovanni degli Eremiti, head to Piazza Pretoria, also known as Piazza della Vergogna due to the nude statues of the central fountain, a Renaissance masterpiece.", info: "Accessibility: Fully accessible. Free entry.", image: "Fontana_pretoria"),
        Step(name: "Santa Maria dell’Ammiraglio", open_time: "09:00", closing_time: "17:30", description: "Visit the Church of the Martorana, famous for its Byzantine mosaics and architecture that blends different styles.", info: "Accessibility: Partially accessible. The main entrance is accessible, but some internal areas might present challenges.", image: "maria_ammiraglio"),
        Step(name: "Quattro Canti", open_time: "00:00", closing_time: "24:00", description: "Continue to the Quattro Canti, an iconic Palermo landmark located at the intersection of the city’s two main streets. The four baroque façades represent the city's four historic districts.", info: "Accessibility: Fully accessible.", image: "quattro_canti"),
        Step(name: "Church of San Cataldo", open_time: "09:00", closing_time: "17:30", description: "End your day with a visit to the Church of San Cataldo, known for its distinctive red domes and Norman architecture.", info: "Accessibility: Partially accessible. The main entrance is accessible, but some internal areas may not be easily accessible.", image: "Chiesa_san_cataldo"),
    ], start_time: "08:30", end_time: "17:30", description: "Suggested for 3 people", category: "Culture", image: "quattro_canti"),
        
    Route(name: "Walk Through History and Nature in Palermo", steps: [
        Step(name: "English Garden", open_time: "07:00", closing_time: "21:00", description: "Start the day with a pleasant stroll through the English Garden, one of the most beautiful and tranquil parks in Palermo. With its wide tree-lined avenues and statues, it’s the perfect place to relax before beginning your cultural exploration.", info: "Accessibility: Fully accessible.", image: "Giardino_inglese"),
        Step(name: "Politeama Theater", open_time: "09:30", closing_time: "18:30", description: "Cultural symbol of the city and home to the Sicilian Symphony Orchestra. Built in 1874, it overlooks the lively Piazza Castelnuovo.", info: "Accessible to the visually impaired. Accessible to people with disabilities accompanied by a caregiver", image: "Politeama"),
        Step(name: "Archaeological Museum 'Antonino Salinas'", open_time: "09:00", closing_time: "18:00", description: "A few minutes' walk from the Politeama, you can visit the Salinas Museum, which houses a rich collection of ancient Sicilian artifacts, offering an immersion into Sicily’s archaeological history.", info: "Accessibility: Accessible for people with disabilities.", image: "Museo_Salinas"),
        Step(name: "Teatro Massimo", open_time: "09:30", closing_time: "19:00", description: "An elegant theater built in 1897 and currently considered the largest in Italy.", info: "Accessible to the visually impaired. Accessible to people with disabilities. Stairlift for people with disabilities. Parking for people with disabilities", image: "teatro_massimo"),
        Step(name: "Casa Professa", open_time: "08:30", closing_time: "17:30", description: "After visiting Teatro Massimo, head to the Church of the Gesù, a masterpiece of Sicilian Baroque, with stunning stuccoes and decorative details that make it one of the most beautiful churches in the city.", info: "Accessibility: Partially accessible.", image: "Casa_professa"),
        Step(name: "Riso Palace Museum", open_time: "09:00", closing_time: "19:00", description: "A short walk from the Church of the Gesù, you’ll find the Riso Palace Museum, offering a modern view of Sicilian art. Its collections of contemporary art add an innovative touch to your cultural day.", info: "Accessibility: Accessible for people with disabilities.", image: "Museo_riso"),
        Step(name: "Villa Trabia", open_time: "07:00", closing_time: "18:00", description: "After a morning full of cultural visits, relax with a walk through the park of Villa Trabia, one of Palermo’s most charming historic gardens. It’s a perfect spot for a quiet break before continuing your tour.", info: "Accessibility: Fully accessible.", image: "villa_trabia"),
        Step(name: "Branciforte Palace", open_time: "09:30", closing_time: "19:30", description: "End the day with a visit to Branciforte Palace, a magnificent historic building that houses art collections and a museum dedicated to ancient Sicilian guilds. This palace represents a perfect blend of tradition and architectural innovation.", info: "Fully accessible.", image: "Palazzo_branciforte"),
    ], start_time: "08:00", end_time: "19:30", description: "Suggested for 5 people", category: "Culture", image: "Palazzo_branciforte"),
        
    Route(name: "Hidden Palermo: A Day of Art, Markets, and Urban Oases", steps: [
        Step(name: "La Zisa", open_time: "09:00", closing_time: "19:00", description: "Start your day by exploring the Zisa Castle, one of the most significant examples of Arab-Norman culture in Palermo. The Zisa will surprise you with its architectural style and garden.", info: "Accessibility: Partially accessible.", image: "LaZisa"),
        Step(name: "Capuchin Catacombs", open_time: "09:00", closing_time: "18:00", description: "After visiting La Zisa, take a short walk or taxi to the Capuchin Catacombs, an eerie yet fascinating place where you can see the historic mummies of monks and citizens.", info: "Accessibility: Not fully accessible.", image: "Catacombe_cappucini"),
        Step(name: "Mercato del Capo", open_time: "07:00", closing_time: "14:00", description: "Continue to the Mercato del Capo, one of the liveliest markets in the city, where you can enjoy Sicilian street food and immerse yourself in the most authentic Palermo atmosphere.", info: "Accessibility: Accessible, but crowded.", image: "Mercato_Capo"),
        Step(name: "Palazzo Abatellis", open_time: "09:00", closing_time: "18:30", description: "After the market, head to Palazzo Abatellis, an art gallery that houses masterpieces of Sicilian painting and sculpture, including the famous 'Triumph of Death.'", info: "Accessibility: Partially accessible.", image: "Palazzo_Abatellis"),
        Step(name: "Church of San Giovanni degli Eremiti", open_time: "09:00", closing_time: "19:00", description: "Proceed to the evocative Church of San Giovanni degli Eremiti, with its characteristic red domes and tranquil cloister, perfect for a short break.", info: "Accessibility: Partially accessible.", image: "san_giovanni"),
        Step(name: "Botanical Garden", open_time: "09:00", closing_time: "18:00", description: "Then head to the Botanical Garden, a peaceful oasis with exotic and rare plants where you can relax and discover botanical species from around the world.", info: "Accessibility: Fully accessible.", image: "Orto_botanico"),
        Step(name: "Villa Giulia and Foro Italico", open_time: "08:00", closing_time: "20:00", description: "End the day with a relaxing walk through Villa Giulia and the Foro Italico, a vast green area overlooking the sea, perfect for enjoying the sunset.", info: "Accessibility: Fully accessible.", image: "Foro_italico"),
    ], start_time: "07:00", end_time: "20:00", description: "Suggested for 4 people", category: "Culture", image: "LaZisa"),
    ])
}
