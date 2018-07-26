import _ from 'lodash';
import React, {Component} from 'react';
import ReactDOM from 'react-dom';
import YTSearch from 'youtube-api-search';

import SearchBar from './components/search_bar';
import VideoList from './components/video_list'
import VideoDetail from './components/video_detail'

const API_KEY = 'AIzaSyBrb66FLZ4vcj51uS0P3alJVlpctGUasvs';

//Create a new component
//some HTML

class App extends Component {
  constructor(props){
    super(props);

    this.state = {
      videos: [],
      selectedVideo: null
     };

    this.videoSearch('surfing')
  }

  videoSearch ( term ) {
    YTSearch({key: API_KEY, term: term}, (videos) => {
      this.setState({
        videos: videos,
        selectedVideo: videos[0]
      });
    });
  }
  render() {
    // en si lo que se hace es que se crea una funcion con debounce que llama a mi funcion y solo puede ser llamada una vez cada 300ms
    const videoSearch=_.debounce((term) => { this.videoSearch(term) }, 300)
    return (
      <div>
        <SearchBar onSearchTermChange={videoSearch} />
        <VideoDetail video={this.state.selectedVideo}/>
        <VideoList
          onVideoSelect={selectedVideo => this.setState({selectedVideo}) }
          videos={this.state.videos}/>
      </div>
    );
  }
}

//take this components generated HTML and put it on the page
ReactDOM.render(<App />, document.querySelector('.container'));
