import Foundation

public class Observable<T: Equatable> {
    private let thread : DispatchQueue
    public var observe : ((T) -> ())?
    public var property : T? {
        willSet(newValue) {
            if let newValue = newValue {
                thread.async {
                    self.observe?(newValue)
                }
            }
        }
    }
    
    init(_ value: T? = nil, thread dispatcherThread: DispatchQueue = DispatchQueue.main) {
        self.thread = dispatcherThread
        self.property = value
    }
}
