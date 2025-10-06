import { ReactNode } from 'react';
import './Frame.css';

export default function Frame({ children }: { children: ReactNode }) {
    return (
        <div className="phone-frame">
            <div className="phone-content">{children}</div>
        </div>
    );
}
