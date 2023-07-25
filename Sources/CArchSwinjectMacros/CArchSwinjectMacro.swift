#if canImport(SwiftSyntaxMacros) && canImport(SwiftCompilerPlugin)
import SwiftSyntaxMacros
import SwiftCompilerPlugin

@main
struct CArchSwinjectPlugin: CompilerPlugin {
    
    let providingMacros: [Macro.Type] = []
}
#endif
