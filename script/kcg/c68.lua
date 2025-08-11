--死神 (KCG)
local s,id=GetID()
function s.initial_effect(c)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_UNCOPYABLE)
	e11:SetCode(EVENT_PREEFFECT_DRAW)
	e11:SetTarget(s.hdtg)
	Duel.RegisterEffect(e11,0)	
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_TURN_END)
	e2:SetCountLimit(1)
	e2:SetLabelObject(e11)
	e2:SetCondition(s.resetcon)
	e2:SetOperation(s.reset)
	Duel.RegisterEffect(e2,0)		
end

function s.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(e:GetOwner():GetControler(), LOCATION_DECK, 0)>0 and ep==e:GetOwner():GetControler() 
    and Duel.GetFlagEffect(e:GetOwner():GetControler(), id)<3 end
	if not Duel.SelectYesNo(e:GetOwner():GetControler(), aux.Stringid(68, 0)) then return end
	Duel.RegisterFlagEffect(e:GetOwner():GetControler(), id, 0, 0, 1)
	e:SetOperation(s.hdop)
end
function s.hdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local ac=Duel.SelectMatchingCard(c:GetControler(), nil, c:GetControler(), LOCATION_DECK, 0, 1, 1, nil)
	--Duel.ShuffleDeck(c:GetControler())
    if #ac<1 then return end
	local tac=ac:GetFirst()
	local tac2=Duel.GetDecktopGroup(c:GetControler(), 1):GetFirst()
	if not tac2 then return end
	aux.SwapEntity(tac, tac2)
    --Duel.MoveSequence(tac, 0)
end

function s.resetcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==e:GetOwner():GetControler()
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetLabelObject()
	ae:Reset()
	e:Reset()
end