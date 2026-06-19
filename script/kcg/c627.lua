--ダークネス・デストロイヤー
--Darkness Destroyer
local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetTarget(s.atg)
	e0:SetOperation(s.aop)
	c:RegisterEffect(e0)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)

	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(185,1))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetTarget(s.retg)
	e7:SetOperation(s.reop)
	c:RegisterEffect(e7)

	local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id,2))
	e6:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(s.condition2)
	e6:SetTarget(s.target)
	e6:SetOperation(s.activate2)
	c:RegisterEffect(e6)
end
s.listed_series={0x316}

function s.atg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
end
function s.afilter(c)
	return c:IsSetCard(0x316)
end
function s.aop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetFieldGroup(1-tp,LOCATION_DECK,0)
	Duel.ConfirmCards(tp,dg)
	local sg=dg:Filter(s.afilter,nil)
	local count=#sg
	if count<1 then Duel.ShuffleDeck(1-tp) return end
	for i=1,count do
		sg=dg:Filter(s.afilter,nil)
		local g=dg:Sub(sg)
		if #g<1 then Duel.ShuffleDeck(1-tp) return end
		local tc=g:RandomSelect(1-tp,1):GetFirst()
		tc:SetCardData(CARDDATA_PICCODE,186)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_FORBIDDEN)
		tc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_SETCODE)
		e3:SetValue(0x316)
		tc:RegisterEffect(e3)
	end
	Duel.ShuffleDeck(1-tp)
end

function s.refilter(c)
	return c:GetSequence()<5
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local gd=Duel.GetMatchingGroup(s.refilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
		return gd:GetCount()>0
	end
end
function s.getflag(g,tp)
	local flag = 0
	for c in aux.Next(g) do
		flag = flag|((1<<c:GetSequence())<<(8+(16*c:GetControler())))
	end
	if tp~=0 then
		flag=((flag<<16)&0xffff)|((flag>>16)&0xffff)
	end
	return ~flag
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gd=Duel.GetMatchingGroup(s.refilter,tp,LOCATION_SZONE,0,nil)
	if gd:GetCount()<1 then return end
	local g=gd:Filter(Card.IsControler,c,tp)
	local g2=gd:Filter(Card.IsControler,c,1-tp)
	if #g<1 and #g2<1 then return end
	local ag=g
	ag:Merge(g2)
	local try=1
	local filter=0 local filter2=0
	while #ag>0 do
		if try==0 and not Duel.SelectYesNo(tp, aux.Stringid(185,1)) then break end
		try=0
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local p=ag:Select(tp,1,1,nil):GetFirst()
		local ttp=p:GetControler()
		--s.getflag(ag,ttp)
		local afilter=0	
		ag:RemoveCard(p)	
		if ttp==tp then 
			g:RemoveCard(p)
			afilter=filter|(0x100<<p:GetSequence())|0xffffe0ff
		else 
			g2:RemoveCard(p) 
			afilter=filter2|(0x100<<p:GetSequence()<<16)|0xe0ffffff
		end				
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local zone
		if ttp==tp then 
			zone=Duel.SelectFieldZone(tp,1,LOCATION_SZONE,0,afilter)
			--filter=filter|zone
		else 
			zone=Duel.SelectFieldZone(tp,1,0,LOCATION_SZONE,afilter)
			--filter2=filter2|zone 
			zone=zone>>16
		end
		local seq=math.log(zone>>8,2)
		local oc=Duel.GetFieldCard(ttp,LOCATION_SZONE,seq)
		if oc then
			Duel.SwapSequence(p,oc)
		else
			Duel.MoveSequence(p,seq)
		end	
	end
end

function s.lvfilter(c,e)
	if not c:IsSetCard(0x316) or c:GetLevel()<5 then return false end
	local chk=false
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	c:RegisterEffect(e1)
	chk=c:IsSummonable(true,nil,1)
	e1:Reset()
	return chk
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.lvfilter,tp,LOCATION_HAND,0,1,nil,e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsMonsterEffect()
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(1-tp,s.lvfilter,1-tp,LOCATION_HAND,0,1,1,nil,e):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_SUMMON_PROC)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		Duel.Summon(1-tp,tc,true,nil)
		e1:Reset()
	end
end