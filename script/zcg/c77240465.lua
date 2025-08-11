--奥利哈刚 元素召唤者(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.target)
	e4:SetOperation(s.activate)
	c:RegisterEffect(e4)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil)
		and Duel.IsPlayerCanSpecialSummon(tp) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	getmetatable(e:GetHandler()).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac1=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac2=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g=sg:Filter(Card.IsCode,nil,ac1,ac2) 
	Duel.ConfirmCards(tp,sg)
	if #g<=0 then Duel.ShuffleHand(1-tp) end
	if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=#g and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp) then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
	local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_ADD_SETCODE)
		  e1:SetValue(0xa50)
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		  c:RegisterEffect(e1)
		  tc=g:GetNext()
end
	Duel.ShuffleHand(1-tp)
end
end