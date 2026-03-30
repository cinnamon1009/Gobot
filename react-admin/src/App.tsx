import { useState } from 'react'
import './App.css'

import axios from 'axios'

function App() {
  const [tiles, setTiles] = useState<{ x: number, y: number }[]>([]);

  const toggleTile = (x: number, y: number) => {
    const exists = tiles.find(t => t.x === x && t.y === y);
    if (exists) {
      setTiles(tiles.filter(t => !(t.x === x && t.y === y))); // 削除（消しゴム）
    } else {
      setTiles([...tiles, { x, y }]); // 追加（ペン）
    }
  };

  // Goサーバーへ送信
  const saveMap = async () => {
    try {
      const response = await axios.post('http://localhost:8080/api/save-map', { data: tiles });
      alert("サーバーに保存しました！: " + response.data.message);
    } catch (error) {
      alert("送信エラー: " + error);
    }
  };

  return (
    <div style={{ padding: '20px', fontFamily: 'sans-serif' }}>
      <h1>マップ管理画面</h1>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(10, 30px)', gap: '2px', marginBottom: '20px' }}>
        {[...Array(100)].map((_, i) => {
          const x = i % 10;
          const y = Math.floor(i / 10);
          const isSelected = tiles.find(t => t.x === x && t.y === y);
          return (
            <div
              key={i}
              onClick={() => toggleTile(x, y)}
              style={{
                width: '30px', height: '30px', border: '1px solid #ccc',
                backgroundColor: isSelected ? '#4285f4' : 'white', cursor: 'pointer'
              }}
            />
          );
        })}
      </div>
      <button onClick={saveMap} style={{ padding: '10px 20px', fontSize: '16px' }}>サーバーへ保存</button>
      <p>現在のタイル数: {tiles.length}</p>
    </div>
  );
}

export default App;