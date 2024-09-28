import SwiftUI
import ParthenoKit

struct HomeView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("logUsername") var logUsername: String = ""
    @State private var searchText = ""
    @State private var us = UserService()
    @State private var rs = RouteService()
    
    // Dati delle categorie
    var categoryNames = ["By Night", "Culture", "Adventure", "Food", "Relax"]
    //var categoryNames = ["Culture", "Food", "By Night", "Relax", "Adventure"]
    let categoryImages = ["night", "teatro_massimo", "surf", "images", "sea"]
    //let categoryImages = ["teatro_massimo", "images", "night", "sea", "surf"]
    
    var filteredCategories: [String] {
        if searchText.isEmpty {
            return categoryNames
        } else {
            return categoryNames.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    let allRoutes = [[
        Route(name: "Historic Palermo", steps: [
            Step(name: "Piazza Marina", open_time: "07:00", closing_time: "20:00", description: "Piazza Marina is a square in the historic center of Palermo, located in the Kalsa district. In the center of the square stands Villa Garibaldi, a garden filled with exotic plants, including the Ficus Magnoloides (the 150-Year Tree of Italian Unification), considered one of the oldest and largest in Italy.", info: "Accessible to people with disabilities accompanied by a caregiver. Free admission", image: "piazza_marina"),
            Step(name: "Palazzo Steri", open_time: "09:00", closing_time: "20:00", description: "Palazzo Steri is located in Piazza Marina in Palermo and is one of the most symbolic places of the city. It was the Palermo seat of the Sicilian Inquisition and since the 1950s it has been the seat of the rectorate of the University of Palermo.", info: "Accessible to the visually impaired. Accessible to people with disabilities. Stairlift for people with disabilities", image: "Palazzo_Steri"),
            Step(name: "Walk along the Foro Italico", open_time: "00:00", closing_time: "24:00", description: "It is a large green area along the Palermo waterfront, stretching from La Cala to Villa Giulia, in the Kalsa district of the city.", info: "Free admission", image: "foro_italico"),
            Step(name: "The Kalsa and the Quattro Pizzi", open_time: "00:00", closing_time: "24:00", description: "It is one of the most important examples of Baroque architecture in Palermo.", info: "Not accessible to people with disabilities", image: "Piazza_Kalsa"),
            Step(name: "Porta Felice", open_time: "00:00", closing_time: "24:00", description: "Monumental entrance gate to Palermo from the sea.", info: "Free admission", image: "Porta_Felice"),
            Step(name: "Dinner at L'Ottava Nota", open_time: "19:30", closing_time: "23:00", description: "Creative Sicilian dishes presented artistically, along with wines to pair, in a minimalist-style venue.", info: "Vegan option.", image: "ottava_nova"),
            Step(name: "Trapezoidal pier", open_time: "19:00", closing_time: "24:00", description: "The Trapezoidal Pier of the port of Palermo houses the Palermo Marina Yachting, a vast area where you can spend time in complete relaxation. The pier allows you to stroll by the sea, savor delicious dishes in the numerous restaurants available, and enjoy shopping thanks to the presence of several boutiques.", info: "", image: "molo_trapezoidale"),
            Step(name: "CALAMIDA", open_time: "17:00", closing_time: "01:00", description: "Chic restaurant-lounge with seafood dishes, live music, and outdoor tables near the port.", info: "Live music", image: "calamida"),
        ], start_time: "18:30", end_time: "02:00", description: "Suggested for 3 people", category: "By Night", image: "piazza_marina"),
        
        Route(name: "Young Palermo", steps: [
            Step(name: "Piazza Castelnuovo", open_time: "00:00", closing_time: "24:00", description: "Here stands the magnificent Politeama Garibaldi Theater. In the evening, the square, with the statue of Garibaldi at its center, is lively and often animated by events or street performers.", info: "", image: "Piazza_Castelnuovo"),
            Step(name: "Politeama Theater", open_time: "09:30", closing_time: "18:30", description: "Cultural symbol of the city and home to the Sicilian Symphony Orchestra. Built in 1874, it overlooks the lively Piazza Castelnuovo.", info: "Accessible to the visually impaired. Accessible to people with disabilities accompanied by a caregiver", image: "politeama"),
            Step(name: "Biga", open_time: "11:30", closing_time: "00:00", description: "Street pizzeria located just a few steps from the Politeama Theater, ideal for enjoying an original aperi-pizza.", info: "Accessible to people with disabilities.", image: "Biga"),
            Step(name: "Walk along Via Libertà", open_time: "00:00", closing_time: "24:00", description: "The tree-lined avenue of Palermo is flanked by luxury shops, boutiques, and elegant buildings.", info: "", image: "Via_Liberta"),
            Step(name: "Piazza Verdi", open_time: "00:00", closing_time: "24:00", description: "One of the most beautiful and lively squares in Palermo. Here stands the majestic Teatro Massimo.", info: "", image: "piazza_versi"),
            Step(name: "Teatro Massimo", open_time: "09:30", closing_time: "19:00", description: "An elegant theater built in 1897 and currently considered the largest in Italy.", info: "Accessible to the visually impaired. Accessible to people with disabilities. Stairlift for people with disabilities. Parking for people with disabilities", image: "TeatroMassimo"),
            Step(name: "Dinner at Casa Obatala", open_time: "18:30", closing_time: "23:00", description: "Historic rustic venue with outdoor tables serving classic Sicilian pasta and seafood dishes.", info: "", image: "Casa_Obatala"),
            Step(name: "Spinnato", open_time: "07:00", closing_time: "01:00", description: "Famous for their artisanal ice creams and Sicilian pastries.", info: "Vegan option", image: "Spinnato"),
            Step(name: "Sabir", open_time: "18:00", closing_time: "02:30", description: "Venue serving apericena with typical Sicilian and Arab products, shisha, and cocktails.", info: "", image: "Sabir"),
        ], start_time: "16:00", end_time: "02:30", description: "Suggested for 2 people", category: "By Night", image: "Sabir"),
        
    Route(name: "Mondello by night", steps: [
        Step(name: "Mida Louge Bar", open_time: "10:30", closing_time: "01:00", description: "Beach venue, perfect for a relaxing drink at sunset.", info: "", image: "mida_bar"),
        Step(name: "Charleston", open_time: "19:30", closing_time: "22:00", description: "The iconic Art Nouveau beach club built on stilts, illuminated by the golden light of the sunset.", info: "", image: "Charleston"),
        Step(name: "Dinner at Trattoria Da Calogero", open_time: "19:00", closing_time: "23:00", description: "One of the most famous restaurants, specializing in fresh fish and traditional Sicilian dishes.", info: "", image: "TrattoriaDa_Calogero"),
        Step(name: "Drink at Baretto", open_time: "08:00", closing_time: "02:00", description: "Historic ice cream shop and bar just a few steps from Mondello beach.", info: "", image: "Baretto_Mondello"),
        Step(name: "Music at Arena", open_time: "19:30", closing_time: "01:00", description: "It is a complex that encompasses various entities offering unique experiences in the fields of food, beverage, and entertainment.", info: "", image: "Arena"),
    ], start_time: "18:30", end_time: "01:30", description: "Suggested for 4 people", category: "By Night", image: "Arena")
        ],
                     [
    Route(name: "A Journey Through History and Monuments", steps: [
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
    ],
     
     [
    Route(name: "Excursion to Ficuzza", steps: [
        Step(name: "Ficuzza Nature Reserve", open_time: "09:00", closing_time: "17:00", description: "Head to the Ficuzza Nature Reserve, where you can choose from several hiking trails. Be sure to visit the Ficuzza Palace, the former hunting lodge of the royal family", info: "", image: "Palazzo_reale_ficuzza"),
        Step(name: "Picnic", open_time: "11:00", closing_time: "15:00", description: "Bring a packed lunch to enjoy in the natural surroundings.", info: "", image: "picnic"),
        Step(name: "Dinner at Stancampiano", open_time: "07:00", closing_time: "02:00", description: "Over 50 flavors of artisanal ice cream in an informal venue with displays of pastries, indoor tables, and outdoor seating.", info: "", image: "brioche_gelato"),
    ], start_time: "09:00", end_time: "17:00", description: "Suggested for 6 people", category: "Adventure", image: "Palazzo_reale_ficuzza"),
        
    Route(name: "Sea and Adventure", steps: [
        Step(name: "Mondello Beach", open_time: "00:00", closing_time: "24:00", description: "Start your day in Mondello, where you can take a swim in the crystal-clear waters.", info: "", image: "Spiaggia_mondello"),
        Step(name: "Capo Gallo Nature Reserve", open_time: "07:00", closing_time: "19:00", description: "Take a hike in the Capo Gallo Nature Reserve. There are various trails offering stunning views and the opportunity to spot wildlife.", info: "", image: "Capo_gallo"),
        Step(name: "Dinner at Da Calogero", open_time: "12:00", closing_time: "00:00", description: "Pizzas and seafood dishes served amid frescoed walls in a colorful venue with outdoor tables overlooking the sea.", info: "", image: "Ristorante_mondello"),
    ], start_time: "07:00", end_time: "00:00", description: "Suggested for 4 people", category: "Adventure", image: "Spiaggia_mondello"),
        
    Route(name: "Trekking and Culture", steps: [
        Step(name: "Monte Pellegrino", open_time: "07:00", closing_time: "22:00", description: "Start your day with a hike on Monte Pellegrino. There are several trails, but the main path offers spectacular views of the city and the sea.", info: "", image: "Escurisone_MonteP"),
        Step(name: "Sanctuary of Santa Rosalia", open_time: "07:00", closing_time: "19:00", description: "Visit to the Sanctuary of Santa Rosalia: Once at the top, visit the sanctuary dedicated to the patron saint of Palermo.", info: "", image: "santuario"),
        Step(name: "Parco della Favorita", open_time: "00:00", closing_time: "24:00", description: "Head to Parco della Favorita, a large urban park. Here you can walk, bike, or simply enjoy the nature around you.", info: "", image: "parco_favorita")
    ], start_time: "07:00", end_time: "23:00", description: "Suggested for 3 people", category: "Adventure", image: "parco_favorita"),
    ],
     
    [
        Route(name: "Food and City", steps: [
            Step(name: "Pasticceria Oscar 1965", open_time: "07:00", closing_time: "21:00", description: "Sicilian specialties in an elegant family restaurant with marble and wood interiors.", info: "", image: "oscar"),
            Step(name: "Antico Caffè Spinnato", open_time: "07:00", closing_time: "01:00", description: "Historic café with terrace, famous for its espresso and classic cannoli. ", info: "", image: "spinnato"),
            Step(name: "Santa Caterina d’Alessandria", open_time: "10:00", closing_time: "18:00", description: "Catholic church in the city center with sumptuous furnishings and a collection of precious works of art.", info: "", image: "alessandria"),
            Step(name: "D2Daniels", open_time: "12:00", closing_time: "23:30", description: "Enjoy this Mediterranean cuisine restaurant, just steps from the beach.", info: "", image: "d2_daniels"),
            Step(name: "Enoteca Butticè", open_time: "16:30", closing_time: "23:30", description: "National and international wines, aperitifs and Sicilian dishes, as well as evening events, in a refined venue.", info: "", image: "buttice"),
            Step(name: "Frida", open_time: "18:30", closing_time: "00:00", description: "Lively restaurant with terrace and colorful Frida Kahlo-themed decor serving traditionally inspired dishes.", info: "", image: "frida"),
            ], start_time: "08:00", end_time: "23:00", description: "Suggested for 2 people", category: "Food", image: "frida"),
        
        Route(name: "Food Culture", steps: [
            Step(name: "Pasticceria Recupero", open_time: "07:00", closing_time: "02:00", description: "Cakes and Sicilian specialties, such as arancini, in a family-run restaurant with retro-style furnishings.", info: "", image: "recupero"),
            Step(name: "Ni Francu u’ Vastiddaru", open_time: "09:00", closing_time: "01:00", description: "Sandwiches and other typical Sicilian street food specialties. ", info: "", image: "franco"),
            Step(name: "Nino u’ Ballerino ", open_time: "07:00", closing_time: "23:30", description: "Rich sandwiches and focaccias, also arancini and pasta, in an iconic takeaway.", info: "", image: "ballerino"),
            ], start_time: "07:00", end_time: "23:30",description: "Suggested for 3 people",  category: "Food", image: "franco"),
        
        Route(name: "Modern Food", steps: [
            Step(name: "Pasticceria Cappello", open_time: "06:30", closing_time: "18:00", description: "Handmade semifreddos, cakes, and chocolates in a venue established in 1940 that also offers pastry courses.", info: "", image: "cappello"),
            Step(name: "Spinnato", open_time: "07:00", closing_time: "01:00", description: "Famous for their artisanal ice creams and Sicilian pastries.", info: "Vegan option", image: "Spinnato"),
            Step(name: "Giardini del Massimo", open_time: "09:00", closing_time: "23:00", description: "A place where you can feel good, savor unique flavors, and indulge in Mediterranean aromas while enjoying this unexpected and charming space, exchanging words, ideas, and emotions.", info: "", image: "giardini_massimo"),
            Step(name: "Cannoli Chiostro di Santa Chiara", open_time: "10:00", closing_time: "17:15", description: "The crispy cannoli filled with a delightful cream, generously sized.", info: "", image: "chiostro"),
            Step(name: "Porta Carbone", open_time: "07:30", closing_time: "22:00", description: "Hearty sandwiches served in a casual venue with counter service overlooking the port.", info: "", image: "carbone"),
            Step(name: "Fusto", open_time: "16:30", closing_time: "00:00", description: "Known for its crisp, refreshing, and clean taste, this beer is famous for its bold hopping, which gives the drink a balanced bitterness, with floral and slightly herbal notes.", info: "", image: "fusto")
        ], start_time: "09:00", end_time: "20:00", description: "Suggested for 2 people", category: "Food", image: "fusto"),
        
        Route(name: "Mondello Food Travel", steps: [
            Step(name: "Bar Antico Chiosco", open_time: "07:00", closing_time: "00:00", description: "L'Antico Chiosco, one of the most welcoming and elegant pastry and gelato bars, not only in Mondello but also in Palermo, is approaching its 85th anniversary. Despite its long history, it retains the appearance of a young, modern, and vibrant establishment.", info: "", image: "antico_chiosco"),
            Step(name: "Pasticceria Scimone", open_time: "07:00", closing_time: "19:30", description: "Cannoli and cassata, along with caponata and arancini, in a venue dating back to 1950 with carefully curated retro-style furnishings.", info: "", image: "scimone"),
            Step(name: "Testaverde", open_time: "09:00", closing_time: "22:00", description: "A rotisserie featuring typical Sicilian products and a fry shop: this Palermo eatery offers home delivery, takeout, and catering reservations.", info: "", image: "testaverde"),
            Step(name: "Bar Touring", open_time: "04:00", closing_time: "00:00", description: "Bar Touring is particularly famous for its specialty: the amazing 'Arancina Bomba' — weighing 400 grams — invented and passed down by master pastry chef Antonino Genovese.", info: "", image: "arancine"),
            Step(name: "Dinner at Trattoria Da Calogero", open_time: "19:00", closing_time: "23:00", description: "One of the most famous restaurants, specializing in fresh fish and traditional Sicilian dishes.", info: "", image: "TrattoriaDa_Calogero"),
        ], start_time: "09:00", end_time: "23:00", description: "Suggested for 5 people", category: "Food", image: "arancine"),
        ],
        
     [
        Route(name: "Wellness and Tranquility", steps: [
            Step(name: "Botanical Garden", open_time: "09:00", closing_time: "18:00", description: "Head to the Botanical Garden, a peaceful oasis with exotic and rare plants where you can relax and discover botanical species from around the world.", info: "Accessibility: Fully accessible.", image: "Orto_botanico"),
            Step(name: "Grand Hotel Piazza Borsa", open_time: "10:00", closing_time: "19:00", description: " Head to the luxurious spa at Grand Hotel Piazza Borsa for a relaxing massage or wellness treatment. The spa offers a range of services, including steam baths and massages, to rejuvenate both body and mind.", info: "", image: "piazza_borsa_spa"),
            Step(name: "Antica Focacceria San Francesco", open_time: "12:00", closing_time: "15:00", description: "For lunch, visit the historic Antica Focacceria San Francesco, known for its traditional Sicilian street food and casual atmosphere. Try Palermo’s famous 'pane con la milza' (spleen sandwich) or other local dishes, while enjoying a relaxed meal in the heart of the city.", info: "", image: "focacceria_san_franc"),
            Step(name: "Villa Malfitano Whitaker", open_time: "09:00", closing_time: "13:00", description: "Spend the afternoon exploring Villa Malfitano Whitaker, an elegant 19th-century villa surrounded by extensive gardens. The villa’s interior is filled with beautiful period furnishings, while the surrounding park offers a peaceful escape with exotic plants and a serene atmosphere.", info: "", image: "villa_malfitano"),
            Step(name: "Bar Marocco", open_time: "07:00", closing_time: "18:00", description: "Take a break at Bar Marocco, located near Piazza San Domenico. This historic café is a perfect place to enjoy a relaxing coffee or traditional Sicilian pastries, like cannoli or sfincione, while soaking in the lively atmosphere of the square.", info: "", image: "bar_marocco"),
            Step(name: "Monte Pellegrino", open_time: "00:00", closing_time: "24:00", description: "drive or take a taxi up Monte Pellegrino, one of Palermo’s iconic natural landmarks. Enjoy breathtaking views of the city and the surrounding sea as the sun sets. You can also visit the Sanctuary of Santa Rosalia, located at the top of the mountain, for a moment of reflection.", info: "", image: "monte_pellegrino"),
            Step(name: "Trattoria ai Cascinari", open_time: "19:30", closing_time: "23:00", description: "End your day with a cozy dinner at Trattoria ai Cascinari, a family-run restaurant serving authentic Sicilian dishes. The warm and friendly atmosphere, paired with traditional favorites like pasta alla Norma and caponata, will be the perfect way to conclude your day of relaxation.", info: "", image: "ai_cascinari"),
        ], start_time: "09:00", end_time: "23.00", description: "Suggested for 4 people", category: "Relax", image: "monte_pellegrino"),
        
        Route(name: "Relaxation and Leisure", steps: [
            Step(name: "Villa Igiea", open_time: "10:00", closing_time: "18:00", description: "After some time at the beach, treat yourself to a luxurious experience at Villa Igiea, a grand historic hotel with a beautiful outdoor pool overlooking the sea. You can take a swim, sunbathe by the pool, or indulge in a rejuvenating spa treatment to relax your body and mind.", info: "", image: "villa_igiea"),
            Step(name: "Alle Terrazze", open_time: "12:00", closing_time: "15:00", description: "Enjoy a leisurely seafood lunch at Alle Terrazze, a beautiful seaside restaurant with stunning views of the bay. Savor freshly caught fish, pasta, and other Sicilian delicacies while enjoying the tranquil atmosphere.", info: "", image: "alle_terrazze"),
            Step(name: "Mondello Beach", open_time: "17:00", closing_time: "20:00", description: "Start your day with a peaceful morning at Mondello Beach, one of the most beautiful beaches near Palermo. You can rent a sunbed and umbrella from one of the private beach clubs, swim in the crystal-clear waters, or simply relax with a book while enjoying the sea breeze", info: "", image: "sea"),
            Step(name: "Cala Rossa Beach Club", open_time: "17:00", closing_time: "22:00", description: "Wind down your day with an aperitif at Cala Rossa Beach Club. Located in the nearby coastal town of Sferracavallo, this chic spot offers stunning views of the sunset over the sea. Enjoy a refreshing cocktail and some light bites while you watch the day fade into evening.", info: "", image: "cala_rossa"),
            Step(name: "Al Faro Verde", open_time: "19:00", closing_time: "23:00", description: "End your relaxing day with a seafood dinner at Al Faro Verde, a local favorite known for its fresh fish and inviting atmosphere. Located near the sea in Sferracavallo, it’s the perfect place to enjoy a calm, delicious meal and reflect on a day of leisure.", info: "", image: "faro_verde"),
        ], start_time: "10:00", end_time: "23:00", description: "Suggested for 3 people", category: "Relax", image: "cala_rossa"),
        
        Route(name: "A Day of Relaxation", steps: [
            Step(name: "Giardino Inglese", open_time: "07:00", closing_time: "19:00", description: "Start your day with a peaceful walk through the English Garden, a beautifully landscaped park with shaded paths, statues, and fountains. It's the perfect place to enjoy a quiet morning surrounded by greenery.", info: "", image: "walkway"),
            Step(name: "Wellness Center", open_time: "10:00", closing_time: "20:00", description: "Pamper yourself with a rejuvenating spa experience at Hammam Palermo. Enjoy a steam bath, massages, and other wellness treatments in a calm and soothing environment.", info: "", image: "spa_wellness"),
            Step(name: "Villa Zito", open_time: "09:00", closing_time: "18:00", description: "After your relaxing spa session, enjoy a light lunch at the café inside Villa Zito, an elegant historic building that also houses a beautiful art collection. You can savor a meal on the terrace overlooking the gardens", info: "", image: "villa_zito"),
            Step(name: "Botanical Garden", open_time: "09:00", closing_time: "18:00", description: "Head to the Botanical Garden, a peaceful oasis with exotic and rare plants where you can relax and discover botanical species from around the world.", info: "Accessibility: Fully accessible.", image: "Orto_botanico"),
            Step(name: "Casa Stagnitta", open_time: "08:00", closing_time: "20:00", description: "This charming café, located in the heart of Palermo, offers a wide selection of teas and artisanal sweets. Relax and enjoy a quiet moment in this cozy spot.", info: "", image: "casa_stagnitta"),
            Step(name: "Walk along the Foro Italico", open_time: "00:00", closing_time: "24:00", description: "It is a large green area along the Palermo waterfront, stretching from La Cala to Villa Giulia, in the Kalsa district of the city.", info: "Free admission", image: "Foro_italico"),
            Step(name: "Trattoria ai Cascinari", open_time: "19:30", closing_time: "23:00", description: "End your day with a cozy dinner at Trattoria ai Cascinari, a family-run restaurant serving authentic Sicilian dishes. The warm and friendly atmosphere, paired with traditional favorites like pasta alla Norma and caponata, will be the perfect way to conclude your day of relaxation.", info: "", image: "ai_cascinari"),
        ], start_time: "07:00", end_time: "19:00", description: "Suggested for 3 people", category: "Relax", image: "Foro_italico")]]
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 5)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Explore")
                            .padding(.horizontal)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        if isLoggedIn {
                            NavigationLink(destination: SettingsView()) {
                                HStack {
                                    let letter = logUsername.first?.lowercased()
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 60, height: 60)
                                        
                                        Image(systemName: "\(letter!).circle.fill")
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }.padding(.leading, 134)
                        } else {
                            NavigationLink(destination: LoginView()) {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 60, height: 60)
                                        
                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }.padding(.leading, 130)
                        }
                    }.padding()
                    
                    // Barra di ricerca
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 10)
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(filteredCategories, id: \.self) { category in
                                let index = categoryNames.firstIndex(of: category)
                                NavigationLink(destination: ListRoute(category: category, image: categoryImages[index!], catRoute: allRoutes[index!])) {
                                    VStack {
                                        Image(categoryImages[index!])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(10)
                                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                                        
                                        Text(category)
                                            .foregroundColor(.black)
                                            .font(.headline)
                                            .cornerRadius(10)
                                            .padding(.leading, 15)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                /*Button(action: {
                    loadData()
                }) {
                    Text("CARICA")
                        .font(.headline)            // Font personalizzato
                        .foregroundColor(.white)    // Colore del testo bianco
                        .padding()                  // Padding interno
                        .frame(maxWidth: .infinity) // Occupa tutta la larghezza disponibile
                        .background(Color.blue)     // Colore di sfondo azzurro
                        .cornerRadius(10)           // Angoli arrotondati
                }
                .padding(.horizontal, 20)*/
            }
        .navigationBarBackButtonHidden(true)
        }
        
        
    }
}
    
extension HomeView {
    
    public func resetAll(){
        let fs = FriendService()
        fs.reset()
    }
    
    public func deteleFriends(){
        let fs = FriendService()
        fs.deleteAllFriends()
    }
    
    public func deleteUsers(){
        let sampleUsers: [User] = [
            User(username: "mike123", password: "mypassword", details: "Adventure seeker", image: "mike_image"),
            User(username: "sara_connor", password: "securePass789", preferences: [1, 1, 0, 1, 0], details: "Tech enthusiast and traveler", image: "sara_image", liked: [], recommended: []),
            User(username: "clark_kent", password: "krypton123", preferences: [0, 0, 1, 1, 1], details: "Nature lover and photographer", image: "clark_image", liked: [], recommended: []),
            User(username: "diana_prince", password: "wonderWoman456", preferences: [1, 0, 1, 0, 1], details: "History buff and art lover", image: "diana_image", liked: [], recommended: []),
            User(username: "tony_stark", password: "ironman123", preferences: [1, 1, 1, 0, 0], details: "Loves technology and good food", image: "tony_image", liked: [], recommended: []),
            User(username: "bruce_wayne", password: "batman123", preferences: [0, 1, 0, 1, 1], details: "Nightlife enthusiast", image: "bruce_image", liked: [], recommended: []),
        ]
        for user in sampleUsers {
            if us.deleteUser(username: user.username) {
                print("Eliminazione dell'utente \(user.username) riuscito!")
            } else {
                print("Errore nell'eliminazione dell'utente \(user.username)!")
            }
        }
    }
    
    public func loadUsers(){
        let sampleUsers: [User] = [
            User(username: "mike123", password: "mypassword", details: "Adventure seeker", image: "mike_image"),
            User(username: "sara_connor", password: "securePass789", preferences: [1, 1, 0, 1, 0], details: "Tech enthusiast and traveler", image: "sara_image", liked: [], recommended: []),
            User(username: "clark_kent", password: "krypton123", preferences: [0, 0, 1, 1, 1], details: "Nature lover and photographer", image: "clark_image", liked: [], recommended: []),
            User(username: "diana_prince", password: "wonderWoman456", preferences: [1, 0, 1, 0, 1], details: "History buff and art lover", image: "diana_image", liked: [], recommended: []),
            User(username: "tony_stark", password: "ironman123", preferences: [1, 1, 1, 0, 0], details: "Loves technology and good food", image: "tony_image", liked: [], recommended: []),
            User(username: "bruce_wayne", password: "batman123", preferences: [0, 1, 0, 1, 1], details: "Nightlife enthusiast", image: "bruce_image", liked: [], recommended: []),
        ]
        
        for user in sampleUsers {
            if us.setUser(user: user) {
                print("Caricamento dell'utente \(user.username) riuscito!")
            } else {
                print("Errore nel caricamento dell'utente \(user.username)!")
            }
        }
    }
    
    public func loadData(){
        let routes = [
            Route(name: "Historic Palermo", steps: [
                Step(name: "Piazza Marina", open_time: "07:00", closing_time: "20:00", description: "Piazza Marina is a square in the historic center of Palermo, located in the Kalsa district. In the center of the square stands Villa Garibaldi, a garden filled with exotic plants, including the Ficus Magnoloides (the 150-Year Tree of Italian Unification), considered one of the oldest and largest in Italy.", info: "Accessible to people with disabilities accompanied by a caregiver. Free admission", image: "piazza_marina"),
                Step(name: "Palazzo Steri", open_time: "09:00", closing_time: "20:00", description: "Palazzo Steri is located in Piazza Marina in Palermo and is one of the most symbolic places of the city. It was the Palermo seat of the Sicilian Inquisition and since the 1950s it has been the seat of the rectorate of the University of Palermo.", info: "Accessible to the visually impaired. Accessible to people with disabilities. Stairlift for people with disabilities", image: "Palazzo_Steri"),
                Step(name: "Walk along the Foro Italico", open_time: "00:00", closing_time: "24:00", description: "It is a large green area along the Palermo waterfront, stretching from La Cala to Villa Giulia, in the Kalsa district of the city.", info: "Free admission", image: "foro_italico"),
                Step(name: "The Kalsa and the Quattro Pizzi", open_time: "00:00", closing_time: "24:00", description: "It is one of the most important examples of Baroque architecture in Palermo.", info: "Not accessible to people with disabilities", image: "Piazza_Kalsa"),
                Step(name: "Porta Felice", open_time: "00:00", closing_time: "24:00", description: "Monumental entrance gate to Palermo from the sea.", info: "Free admission", image: "Porta_Felice"),
                Step(name: "Dinner at L'Ottava Nota", open_time: "19:30", closing_time: "23:00", description: "Creative Sicilian dishes presented artistically, along with wines to pair, in a minimalist-style venue.", info: "Vegan option.", image: "ottava_nova"),
                Step(name: "Trapezoidal pier", open_time: "19:00", closing_time: "24:00", description: "The Trapezoidal Pier of the port of Palermo houses the Palermo Marina Yachting, a vast area where you can spend time in complete relaxation. The pier allows you to stroll by the sea, savor delicious dishes in the numerous restaurants available, and enjoy shopping thanks to the presence of several boutiques.", info: "", image: "molo_trapezoidale"),
                Step(name: "CALAMIDA", open_time: "17:00", closing_time: "01:00", description: "Chic restaurant-lounge with seafood dishes, live music, and outdoor tables near the port.", info: "Live music", image: "calamida"),
            ], start_time: "18:30", end_time: "02:00", description: "Suggested for 3 people", category: "By Night", image: "piazza_marina"),
            
            Route(name: "Young Palermo", steps: [
                Step(name: "Piazza Castelnuovo", open_time: "00:00", closing_time: "24:00", description: "Here stands the magnificent Politeama Garibaldi Theater. In the evening, the square, with the statue of Garibaldi at its center, is lively and often animated by events or street performers.", info: "", image: "Piazza_Castelnuovo"),
                Step(name: "Politeama Theater", open_time: "09:30", closing_time: "18:30", description: "Cultural symbol of the city and home to the Sicilian Symphony Orchestra. Built in 1874, it overlooks the lively Piazza Castelnuovo.", info: "Accessible to the visually impaired. Accessible to people with disabilities accompanied by a caregiver", image: "politeama"),
                Step(name: "Biga", open_time: "11:30", closing_time: "00:00", description: "Street pizzeria located just a few steps from the Politeama Theater, ideal for enjoying an original aperi-pizza.", info: "Accessible to people with disabilities.", image: "Biga"),
                Step(name: "Walk along Via Libertà", open_time: "00:00", closing_time: "24:00", description: "The tree-lined avenue of Palermo is flanked by luxury shops, boutiques, and elegant buildings.", info: "", image: "Via_Liberta"),
                Step(name: "Piazza Verdi", open_time: "00:00", closing_time: "24:00", description: "One of the most beautiful and lively squares in Palermo. Here stands the majestic Teatro Massimo.", info: "", image: "piazza_versi"),
                Step(name: "Teatro Massimo", open_time: "09:30", closing_time: "19:00", description: "An elegant theater built in 1897 and currently considered the largest in Italy.", info: "Accessible to the visually impaired. Accessible to people with disabilities. Stairlift for people with disabilities. Parking for people with disabilities", image: "TeatroMassimo"),
                Step(name: "Dinner at Casa Obatala", open_time: "18:30", closing_time: "23:00", description: "Historic rustic venue with outdoor tables serving classic Sicilian pasta and seafood dishes.", info: "", image: "Casa_Obatala"),
                Step(name: "Spinnato", open_time: "07:00", closing_time: "01:00", description: "Famous for their artisanal ice creams and Sicilian pastries.", info: "Vegan option", image: "Spinnato"),
                Step(name: "Sabir", open_time: "18:00", closing_time: "02:30", description: "Venue serving apericena with typical Sicilian and Arab products, shisha, and cocktails.", info: "", image: "Sabir"),
            ], start_time: "16:00", end_time: "02:30", description: "Suggested for 2 people", category: "By Night", image: "Sabir"),
            
        Route(name: "Mondello by night", steps: [
            Step(name: "Mida Louge Bar", open_time: "10:30", closing_time: "01:00", description: "Beach venue, perfect for a relaxing drink at sunset.", info: "", image: "mida_bar"),
            Step(name: "Charleston", open_time: "19:30", closing_time: "22:00", description: "The iconic Art Nouveau beach club built on stilts, illuminated by the golden light of the sunset.", info: "", image: "Charleston"),
            Step(name: "Dinner at Trattoria Da Calogero", open_time: "19:00", closing_time: "23:00", description: "One of the most famous restaurants, specializing in fresh fish and traditional Sicilian dishes.", info: "", image: "TrattoriaDa_Calogero"),
            Step(name: "Drink at Baretto", open_time: "08:00", closing_time: "02:00", description: "Historic ice cream shop and bar just a few steps from Mondello beach.", info: "", image: "Baretto_Mondello"),
            Step(name: "Music at Arena", open_time: "19:30", closing_time: "01:00", description: "It is a complex that encompasses various entities offering unique experiences in the fields of food, beverage, and entertainment.", info: "", image: "Arena"),
        ], start_time: "18:30", end_time: "01:30", description: "Suggested for 4 people", category: "By Night", image: "Arena"),
            
        Route(name: "A Journey Through History and Monuments", steps: [
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
            
        Route(name: "Excursion to Ficuzza", steps: [
            Step(name: "Ficuzza Nature Reserve", open_time: "09:00", closing_time: "17:00", description: "Head to the Ficuzza Nature Reserve, where you can choose from several hiking trails. Be sure to visit the Ficuzza Palace, the former hunting lodge of the royal family", info: "", image: "Palazzo_reale_ficuzza"),
            Step(name: "Picnic", open_time: "11:00", closing_time: "15:00", description: "Bring a packed lunch to enjoy in the natural surroundings.", info: "", image: "picnic"),
            Step(name: "Dinner at Stancampiano", open_time: "07:00", closing_time: "02:00", description: "Over 50 flavors of artisanal ice cream in an informal venue with displays of pastries, indoor tables, and outdoor seating.", info: "", image: "brioche_gelato"),
        ], start_time: "09:00", end_time: "17:00", description: "Suggested for 6 people", category: "Adventure", image: "Palazzo_reale_ficuzza"),
            
        Route(name: "Sea and Adventure", steps: [
            Step(name: "Mondello Beach", open_time: "00:00", closing_time: "24:00", description: "Start your day in Mondello, where you can take a swim in the crystal-clear waters.", info: "", image: "Spiaggia_mondello"),
            Step(name: "Capo Gallo Nature Reserve", open_time: "07:00", closing_time: "19:00", description: "Take a hike in the Capo Gallo Nature Reserve. There are various trails offering stunning views and the opportunity to spot wildlife.", info: "", image: "Capo_gallo"),
            Step(name: "Dinner at Da Calogero", open_time: "12:00", closing_time: "00:00", description: "Pizzas and seafood dishes served amid frescoed walls in a colorful venue with outdoor tables overlooking the sea.", info: "", image: "Ristorante_mondello"),
        ], start_time: "07:00", end_time: "00:00", description: "Suggested for 4 people", category: "Adventure", image: "Spiaggia_mondello"),
            
        Route(name: "Trekking and Culture", steps: [
            Step(name: "Monte Pellegrino", open_time: "07:00", closing_time: "22:00", description: "Start your day with a hike on Monte Pellegrino. There are several trails, but the main path offers spectacular views of the city and the sea.", info: "", image: "Escurisone_MonteP"),
            Step(name: "Sanctuary of Santa Rosalia", open_time: "07:00", closing_time: "19:00", description: "Visit to the Sanctuary of Santa Rosalia: Once at the top, visit the sanctuary dedicated to the patron saint of Palermo.", info: "", image: "santuario"),
            Step(name: "Parco della Favorita", open_time: "00:00", closing_time: "24:00", description: "Head to Parco della Favorita, a large urban park. Here you can walk, bike, or simply enjoy the nature around you.", info: "", image: "parco_favorita")
        ], start_time: "07:00", end_time: "23:00", description: "Suggested for 3 people", category: "Adventure", image: "parco_favorita"),
           
            Route(name: "Food and City", steps: [
                Step(name: "Pasticceria Oscar 1965", open_time: "07:00", closing_time: "21:00", description: "Sicilian specialties in an elegant family restaurant with marble and wood interiors.", info: "", image: "oscar"),
                Step(name: "Antico Caffè Spinnato", open_time: "07:00", closing_time: "01:00", description: "Historic café with terrace, famous for its espresso and classic cannoli. ", info: "", image: "spinnato"),
                Step(name: "Santa Caterina d’Alessandria", open_time: "10:00", closing_time: "18:00", description: "Catholic church in the city center with sumptuous furnishings and a collection of precious works of art.", info: "", image: "alessandria"),
                Step(name: "D2Daniels", open_time: "12:00", closing_time: "23:30", description: "Enjoy this Mediterranean cuisine restaurant, just steps from the beach.", info: "", image: "d2_daniels"),
                Step(name: "Enoteca Butticè", open_time: "16:30", closing_time: "23:30", description: "National and international wines, aperitifs and Sicilian dishes, as well as evening events, in a refined venue.", info: "", image: "buttice"),
                Step(name: "Frida", open_time: "18:30", closing_time: "00:00", description: "Lively restaurant with terrace and colorful Frida Kahlo-themed decor serving traditionally inspired dishes.", info: "", image: "frida"),
                ], start_time: "08:00", end_time: "23:00", description: "Suggested for 2 people", category: "Food", image: "frida"),
            
            Route(name: "Food Culture", steps: [
                Step(name: "Pasticceria Recupero", open_time: "07:00", closing_time: "02:00", description: "Cakes and Sicilian specialties, such as arancini, in a family-run restaurant with retro-style furnishings.", info: "", image: "recupero"),
                Step(name: "Ni Francu u’ Vastiddaru", open_time: "09:00", closing_time: "01:00", description: "Sandwiches and other typical Sicilian street food specialties. ", info: "", image: "franco"),
                Step(name: "Nino u’ Ballerino ", open_time: "07:00", closing_time: "23:30", description: "Rich sandwiches and focaccias, also arancini and pasta, in an iconic takeaway.", info: "", image: "ballerino"),
                ], start_time: "07:00", end_time: "23:30",description: "Suggested for 3 people",  category: "Food", image: "franco"),
            
            Route(name: "Modern Food", steps: [
                Step(name: "Pasticceria Cappello", open_time: "06:30", closing_time: "18:00", description: "Handmade semifreddos, cakes, and chocolates in a venue established in 1940 that also offers pastry courses.", info: "", image: "cappello"),
                Step(name: "Spinnato", open_time: "07:00", closing_time: "01:00", description: "Famous for their artisanal ice creams and Sicilian pastries.", info: "Vegan option", image: "Spinnato"),
                Step(name: "Giardini del Massimo", open_time: "09:00", closing_time: "23:00", description: "A place where you can feel good, savor unique flavors, and indulge in Mediterranean aromas while enjoying this unexpected and charming space, exchanging words, ideas, and emotions.", info: "", image: "giardini_massimo"),
                Step(name: "Cannoli Chiostro di Santa Chiara", open_time: "10:00", closing_time: "17:15", description: "The crispy cannoli filled with a delightful cream, generously sized.", info: "", image: "chiostro"),
                Step(name: "Porta Carbone", open_time: "07:30", closing_time: "22:00", description: "Hearty sandwiches served in a casual venue with counter service overlooking the port.", info: "", image: "carbone"),
                Step(name: "Fusto", open_time: "16:30", closing_time: "00:00", description: "Known for its crisp, refreshing, and clean taste, this beer is famous for its bold hopping, which gives the drink a balanced bitterness, with floral and slightly herbal notes.", info: "", image: "fusto")
            ], start_time: "09:00", end_time: "20:00", description: "Suggested for 2 people", category: "Food", image: "fusto"),
            
            Route(name: "Mondello Food Travel", steps: [
                Step(name: "Bar Antico Chiosco", open_time: "07:00", closing_time: "00:00", description: "L'Antico Chiosco, one of the most welcoming and elegant pastry and gelato bars, not only in Mondello but also in Palermo, is approaching its 85th anniversary. Despite its long history, it retains the appearance of a young, modern, and vibrant establishment.", info: "", image: "antico_chiosco"),
                Step(name: "Pasticceria Scimone", open_time: "07:00", closing_time: "19:30", description: "Cannoli and cassata, along with caponata and arancini, in a venue dating back to 1950 with carefully curated retro-style furnishings.", info: "", image: "scimone"),
                Step(name: "Testaverde", open_time: "09:00", closing_time: "22:00", description: "A rotisserie featuring typical Sicilian products and a fry shop: this Palermo eatery offers home delivery, takeout, and catering reservations.", info: "", image: "testaverde"),
                Step(name: "Bar Touring", open_time: "04:00", closing_time: "00:00", description: "Bar Touring is particularly famous for its specialty: the amazing 'Arancina Bomba' — weighing 400 grams — invented and passed down by master pastry chef Antonino Genovese.", info: "", image: "arancine"),
                Step(name: "Dinner at Trattoria Da Calogero", open_time: "19:00", closing_time: "23:00", description: "One of the most famous restaurants, specializing in fresh fish and traditional Sicilian dishes.", info: "", image: "TrattoriaDa_Calogero"),
            ], start_time: "09:00", end_time: "23:00", description: "Suggested for 5 people", category: "Food", image: "arancine"),
            
            Route(name: "Wellness and Tranquility", steps: [
                Step(name: "Botanical Garden", open_time: "09:00", closing_time: "18:00", description: "Head to the Botanical Garden, a peaceful oasis with exotic and rare plants where you can relax and discover botanical species from around the world.", info: "Accessibility: Fully accessible.", image: "Orto_botanico"),
                Step(name: "Grand Hotel Piazza Borsa", open_time: "10:00", closing_time: "19:00", description: " Head to the luxurious spa at Grand Hotel Piazza Borsa for a relaxing massage or wellness treatment. The spa offers a range of services, including steam baths and massages, to rejuvenate both body and mind.", info: "", image: "piazza_borsa_spa"),
                Step(name: "Antica Focacceria San Francesco", open_time: "12:00", closing_time: "15:00", description: "For lunch, visit the historic Antica Focacceria San Francesco, known for its traditional Sicilian street food and casual atmosphere. Try Palermo’s famous 'pane con la milza' (spleen sandwich) or other local dishes, while enjoying a relaxed meal in the heart of the city.", info: "", image: "focacceria_san_franc"),
                Step(name: "Villa Malfitano Whitaker", open_time: "09:00", closing_time: "13:00", description: "Spend the afternoon exploring Villa Malfitano Whitaker, an elegant 19th-century villa surrounded by extensive gardens. The villa’s interior is filled with beautiful period furnishings, while the surrounding park offers a peaceful escape with exotic plants and a serene atmosphere.", info: "", image: "villa_malfitano"),
                Step(name: "Bar Marocco", open_time: "07:00", closing_time: "18:00", description: "Take a break at Bar Marocco, located near Piazza San Domenico. This historic café is a perfect place to enjoy a relaxing coffee or traditional Sicilian pastries, like cannoli or sfincione, while soaking in the lively atmosphere of the square.", info: "", image: "bar_marocco"),
                Step(name: "Monte Pellegrino", open_time: "00:00", closing_time: "24:00", description: "drive or take a taxi up Monte Pellegrino, one of Palermo’s iconic natural landmarks. Enjoy breathtaking views of the city and the surrounding sea as the sun sets. You can also visit the Sanctuary of Santa Rosalia, located at the top of the mountain, for a moment of reflection.", info: "", image: "monte_pellegrino"),
                Step(name: "Trattoria ai Cascinari", open_time: "19:30", closing_time: "23:00", description: "End your day with a cozy dinner at Trattoria ai Cascinari, a family-run restaurant serving authentic Sicilian dishes. The warm and friendly atmosphere, paired with traditional favorites like pasta alla Norma and caponata, will be the perfect way to conclude your day of relaxation.", info: "", image: "ai_cascinari"),
            ], start_time: "09:00", end_time: "23.00", description: "Suggested for 4 people", category: "Relax", image: "monte_pellegrino"),
            
            Route(name: "Relaxation and Leisure", steps: [
                Step(name: "Villa Igiea", open_time: "10:00", closing_time: "18:00", description: "After some time at the beach, treat yourself to a luxurious experience at Villa Igiea, a grand historic hotel with a beautiful outdoor pool overlooking the sea. You can take a swim, sunbathe by the pool, or indulge in a rejuvenating spa treatment to relax your body and mind.", info: "", image: "villa_igiea"),
                Step(name: "Alle Terrazze", open_time: "12:00", closing_time: "15:00", description: "Enjoy a leisurely seafood lunch at Alle Terrazze, a beautiful seaside restaurant with stunning views of the bay. Savor freshly caught fish, pasta, and other Sicilian delicacies while enjoying the tranquil atmosphere.", info: "", image: "alle_terrazze"),
                Step(name: "Mondello Beach", open_time: "17:00", closing_time: "20:00", description: "Start your day with a peaceful morning at Mondello Beach, one of the most beautiful beaches near Palermo. You can rent a sunbed and umbrella from one of the private beach clubs, swim in the crystal-clear waters, or simply relax with a book while enjoying the sea breeze", info: "", image: "sea"),
                Step(name: "Cala Rossa Beach Club", open_time: "17:00", closing_time: "22:00", description: "Wind down your day with an aperitif at Cala Rossa Beach Club. Located in the nearby coastal town of Sferracavallo, this chic spot offers stunning views of the sunset over the sea. Enjoy a refreshing cocktail and some light bites while you watch the day fade into evening.", info: "", image: "cala_rossa"),
                Step(name: "Al Faro Verde", open_time: "19:00", closing_time: "23:00", description: "End your relaxing day with a seafood dinner at Al Faro Verde, a local favorite known for its fresh fish and inviting atmosphere. Located near the sea in Sferracavallo, it’s the perfect place to enjoy a calm, delicious meal and reflect on a day of leisure.", info: "", image: "faro_verde"),
            ], start_time: "10:00", end_time: "23:00", description: "Suggested for 3 people", category: "Relax", image: "cala_rossa"),
            
            Route(name: "A Day of Relaxation", steps: [
                Step(name: "Giardino Inglese", open_time: "07:00", closing_time: "19:00", description: "Start your day with a peaceful walk through the English Garden, a beautifully landscaped park with shaded paths, statues, and fountains. It's the perfect place to enjoy a quiet morning surrounded by greenery.", info: "", image: "walkway"),
                Step(name: "Wellness Center", open_time: "10:00", closing_time: "20:00", description: "Pamper yourself with a rejuvenating spa experience at Hammam Palermo. Enjoy a steam bath, massages, and other wellness treatments in a calm and soothing environment.", info: "", image: "spa_wellness"),
                Step(name: "Villa Zito", open_time: "09:00", closing_time: "18:00", description: "After your relaxing spa session, enjoy a light lunch at the café inside Villa Zito, an elegant historic building that also houses a beautiful art collection. You can savor a meal on the terrace overlooking the gardens", info: "", image: "villa_zito"),
                Step(name: "Botanical Garden", open_time: "09:00", closing_time: "18:00", description: "Head to the Botanical Garden, a peaceful oasis with exotic and rare plants where you can relax and discover botanical species from around the world.", info: "Accessibility: Fully accessible.", image: "Orto_botanico"),
                Step(name: "Casa Stagnitta", open_time: "08:00", closing_time: "20:00", description: "This charming café, located in the heart of Palermo, offers a wide selection of teas and artisanal sweets. Relax and enjoy a quiet moment in this cozy spot.", info: "", image: "casa_stagnitta"),
                Step(name: "Walk along the Foro Italico", open_time: "00:00", closing_time: "24:00", description: "It is a large green area along the Palermo waterfront, stretching from La Cala to Villa Giulia, in the Kalsa district of the city.", info: "Free admission", image: "Foro_italico"),
                Step(name: "Trattoria ai Cascinari", open_time: "19:30", closing_time: "23:00", description: "End your day with a cozy dinner at Trattoria ai Cascinari, a family-run restaurant serving authentic Sicilian dishes. The warm and friendly atmosphere, paired with traditional favorites like pasta alla Norma and caponata, will be the perfect way to conclude your day of relaxation.", info: "", image: "ai_cascinari"),
            ], start_time: "07:00", end_time: "19:00", description: "Suggested for 3 people", category: "Relax", image: "Foro_italico")
        ]
        
        for route in routes {
            if rs.setRoute(route: route) {
                print("Caricamento dell'itinerario \(route.name) riuscito!")
            } else {
                print("Errore nel caricamento dell'itinerario \(route.name)!")
            }
        }
    }
}
        


struct MainView: View {
    @State var selection: Int = 1
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some View {
        TabView(selection: $selection) {
            if isLoggedIn {
                UserView()
                    .tabItem {
                        Label("Travels", systemImage: "map.fill")
                    }.tag(0)
                
                HomeView()
                    .tabItem {
                        Label("Explore", systemImage: "magnifyingglass")
                    }.tag(1)
                
                GroupView()
                    .tabItem {
                        Label("Groups", systemImage: "person.3.fill")
                    }.tag(2)
            } else {
                HomeView()
                    .tabItem {
                        Label("Explore", systemImage: "magnifyingglass")
                    }.tag(1)
            }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = .white
        }
    }
}
#Preview {
    MainView()
}
