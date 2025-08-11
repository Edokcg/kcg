--自然妖精·蒲公英
local s, id = GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x2a),1,1)
	c:EnableReviveLimit()

	--force mzone
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_FORCE_MZONE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
	e2:SetTarget(s.target)
	e2:SetValue(s.frcval)
	c:RegisterEffect(e2)
	--Special summon procedure (from extra deck)
	--effect gain
	
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_EXTRA,0)
	e5:SetCountLimit(1,id)
	e5:SetTarget(s.eftg)
	e5:SetLabelObject(e2)
	c:RegisterEffect(e5)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.sprcon)
	e2:SetTarget(s.sprtg)
	e2:SetOperation(s.sprop)
	c:RegisterEffect(e2)
 --Extra Material
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_FIELD)
	e20:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e20:SetRange(LOCATION_MZONE)
	e20:SetTargetRange(LOCATION_GRAVE+LOCATION_DECK+LOCATION_MZONE+LOCATION_HAND,0)
	e20:SetCountLimit(1,id)
	e20:SetTarget(aux.TargetBoolFunction(Card.IsAbleToRemove))
	e20:SetOperation(Fusion.BanishMaterial)
	e20:SetValue(s.mtval)
	c:RegisterEffect(e20)
end
s.listed_series={0x2a}

function s.target(e,c)
	return c:GetFlagEffect(1690)~=0
end
function s.target2(e,c)
	return c:IsSetCard(0x2a) and c:IsType(TYPE_SYNCHRO)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(1690) and c:IsType(TYPE_LINK)
end
function s.frcval(e,c,fp,rp,r)
	local zone=0
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return bit.band(zone,0x1f)
end
function s.checkzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return bit.band(zone,0x1f)
end

function s.mfilter(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	return Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function s.scfilter(c,mg)
	return c:IsSynchroSummonable(nil,mg) and c:IsSetCard(0x2a)
end
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local tc=Duel.SelectMatchingCard(tp,s.mfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp,e:GetHandler())
	local mg=Group.FromCards(tc,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.scfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg):GetFirst()
	if sc then Duel.SynchroSummon(tp,sc,nil,mg) end
end

function s.mtval(e,c)
	if not c then return false end
	return c:IsSetCard(0x2a) and c:IsControler(e:GetHandlerPlayer()) 
end
function s.eftg(e,c)
	return c:IsSetCard(0x2a) and c:IsType(TYPE_SYNCHRO)
end
function s.sprfilter(c)
	return  c:IsAbleToRemoveAsCost() and c:HasLevel()
end
function s.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_MZONE+LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil)
	return c:IsType(TYPE_TUNER) and g:IsExists(s.sprfilter2,1,c,tp,c,sc)
end
function s.sprfilter2(c,tp,mc,sc)
	local sg=Group.FromCards(c,mc)
	return (math.abs((c:GetLevel()-mc:GetLevel()))==1) and not c:IsType(TYPE_TUNER) and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_MZONE+LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil)
	return g:IsExists(s.sprfilter1,1,nil,tp,g,c)
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_MZONE+LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local g1=g:Filter(s.sprfilter1,nil,tp,g,c)
	local mg1=aux.SelectUnselectGroup(g1,e,tp,1,1,nil,1,tp,HINTMSG_REMOVE,nil,nil,true)
	if #mg1>0 then
		local mc=mg1:GetFirst()
		local g2=g:Filter(s.sprfilter2,mc,tp,mc,c,mc:GetLevel())
		local mg2=aux.SelectUnselectGroup(g2,e,tp,1,1,nil,1,tp,HINTMSG_REMOVE,nil,nil,true)
		mg1:Merge(mg2)
	end
	if #mg1==2 then
		mg1:KeepAlive()
		e:SetLabelObject(mg1)
		return true
	end
	return false
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end