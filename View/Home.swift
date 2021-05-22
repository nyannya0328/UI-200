//
//  Home.swift
//  UI-200
//
//  Created by にゃんにゃん丸 on 2021/05/22.
//

import SwiftUI

struct Home: View {
    @State var count : Int = 2
    var body: some View {
        NavigationView{
            
            ReflesheableScroll {
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 12), count: 3),spacing: 10, content: {
                 
                    
                    ForEach(1..<count,id:\.self){index in
                        
                        
                        GeometryReader{proxy in
                            
                            let frame = proxy.frame(in:.global)
                            
                            Image("p\(index)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: frame.width, height: 183)
                                .cornerRadius(10)
                        }
                        .frame(height: 183)
                        
                    }
                    
                })
                .padding()
                
                
            } onReflesh: {control in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3){
                    self.count += 1
                    control.endRefreshing()
                    
                    
                }
                
            }
            .navigationTitle("PULL ME")
            .navigationBarTitleDisplayMode(.inline)
          

            
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct ReflesheableScroll<Content:View> : UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    
    var content : Content
    var onReflesh : (UIRefreshControl)->()
    var RefleshControl = UIRefreshControl()
    
    init(@ViewBuilder content : @escaping ()->Content,onReflesh:@escaping (UIRefreshControl) -> ()) {
        
        self.content = content()
        self.onReflesh = onReflesh
        
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        
        let view = UIScrollView()
        setUpView(view: view)
        RefleshControl.attributedTitle = NSAttributedString(string: "Pull!")
        RefleshControl.tintColor = .green
        RefleshControl.addTarget(context.coordinator, action: #selector(context.coordinator.onReflesh), for:.valueChanged )
        
        view.refreshControl = RefleshControl
        
        
       
        
        return view
        
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
        setUpView(view: uiView)
        
    }
    
    func setUpView(view : UIScrollView){
        
        let hostView = UIHostingController(rootView: content.frame(maxHeight: .infinity, alignment: .top))
        
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        
        let contains = [
        
            hostView.view.topAnchor.constraint(equalTo: view.topAnchor),
            
            hostView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            hostView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            hostView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            hostView.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            hostView.view.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor,constant: 1),
        
        ]
        view.subviews.last?.removeFromSuperview()
        
        view.addSubview(hostView.view)
        
        view.addConstraints(contains)
        
        
    }
    
    class Coordinator : NSObject{
        
        var parent : ReflesheableScroll
        
        init(parent : ReflesheableScroll) {
            self.parent = parent
        }
        
        @objc func onReflesh(){
            
            parent.onReflesh(parent.RefleshControl)
            
        }
        
        
        
    }
    
}
