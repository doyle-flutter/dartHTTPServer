<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DODO</title>
</head>
<body>
    <h1>안녕하세요</h1>
    <p>DO 를 적용중입니다</p>
    <p>
        <do> data </do>
    </p>
    <ul>
        <li><do> DATA </do></li>
    </ul>
    <ol>
        <li><do> data </do></li>
        <li><do> body </do> : Dart Server</li>
    </ol>
    
    

    <div id="root"></div>
    <script src="https://unpkg.com/react@17/umd/react.development.js" crossorigin></script>
    <script src="https://unpkg.com/react-dom@17/umd/react-dom.development.js" crossorigin></script>
    <script src="https://unpkg.com/babel-standalone@6/babel.min.js"></script>
    <script type="text/babel">
                // HOOK
        const {useState, useEffect} = React;
        
        const Wrapper = (props) => {
            const [data, setState] = useState(0);
            return (
                <div>
                    <div>{"Hi ! React HOOK !"}</div>
                    <StateTest data={data} func={setState}/>
                    <EffetTest data={data}/>
                </div>
            );
        }; 
        
        // * useState [render 이전]
        // - const [state, setState] = useState(initialState);
        // state : 현재 상태 값, setState : 업데이트 함수 - 호출시 render
        const StateTest = (props) => (
            <div style={AllStyle.stateTestStyle}>
                <p>{"useState HOOK Render 이전"}</p>
                <p>{props.data}</p>
                <button onClick={() => props.func(props.data+1)}>{"UP"}</button>
            </div>
        );

        // * useEffect [render 이후] 
        // - useEffect(didUpdateFunction, [values]?) 
        // values : 비교 할 상태, 호출 함수 didUpdateFunction
        // == componentDidMount, componentWillUnmount, componentWillUnmount
        const EffectTestTxt = (props) => (<p>{props.data}</p>);
        const EffetTest = (props) => {
            let [titleTxt, setState] = useState("");
            useEffect(() => setState(titleTxt = `${props.data}`));
            return (
                <div style={AllStyle.effectTestStyle}>
                    <p>{"useEffect HOOK Render 이후"}</p>
                    <EffectTestTxt data={titleTxt}/>
                </div>
            )
        };
        
        const AllStyle = {
            stateTestStyle : {
                color: 'red',
                border: '1px solid black',
                padding: '20px',
                margin: '10px',
            },
            effectTestStyle : {
                color: 'blue',
                border: '1px solid black',
                padding: '20px',
                margin: '10px',
            },
        };
        ReactDOM.render(<Wrapper />, document.getElementById('root'));
    </script>
</body>
</html>