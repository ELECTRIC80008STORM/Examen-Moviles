import SwiftUI

struct ContentView: View {
    // @StateObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            List(/* contentViewModel.pokemonList */[PokemonBase]()) { pokemonBase in
                NavigationLink {
//                    PokemonDetailView(pokemonBase: pokemonBase)
                } label: {
                    HStack {
//                        WebImage(url: URL(string: pokemonBase.perfil?.sprites.front_default ?? ""))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48, alignment: .center)
                        Text(pokemonBase.pokemon.name)
                    }
                }
            }
        }
        /*
        .onAppear {
            Task {
                await contentViewModel.getPokemonList()
            }
        }
        */
    }
    
    /*
    func getPokemonList() async {
        let pokemonRepository = PokemonRepository()
        let result = await pokemonRepository.getPokemonList(limit: 1279)
        
        var tempPokemonList = [PokemonBase]()
        for pokemon in result!.results {
            let numberPokemon = Int(pokemon.url.split(separator: "/")[5])!
            
            let infoPokemon = await pokemonRepository.getPokemonInfo(numberPokemon: Int(String(numberPokemon))!)
            let tempPokemon = PokemonBase(id: Int(String(numberPokemon))!, pokemon: pokemon, perfil: infoPokemon)
            tempPokemonList.append(tempPokemon)
        }
        contentViewModel.pokemonList = tempPokemonList
    }
    */
}
