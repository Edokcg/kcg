--盟军·次世代滑翔人(neet)
local s,id=GetID()
function s.initial_effect(c)
	Link.AddProcedure(c,nil,2,3,s.lcheck)
	--draw
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_DRAW)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(s.drcon)
	e0:SetTarget(s.drtg)
	e0:SetOperation(s.drop)
	c:RegisterEffect(e0)
	--Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function(_,tp)return Duel.IsTurnPlayer(1-tp) and Duel.IsMainPhase() end)
	e1:SetTarget(s.sctg)
	e1:SetOperation(s.scop)
	c:RegisterEffect(e1)
end
s.listed_series={0x2}
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x2,lc,sumtype,tp)
end
function s.cfilter(c,ec)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and ec:GetLinkedGroup():IsContains(c) and c:IsSetCard(0x2)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,e:GetHandler())
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function s.filter(c,mg)
	return mg:IsContains(c) and c:IsFaceup() and c:IsCanBeSynchroMaterial()
end
function s.synfilter(c,mg,sc,set)
	local reset={}
	if not set then
		for tc in aux.Next(mg) do
			local e1=Effect.CreateEffect(sc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
			tc:RegisterEffect(e1)
			table.insert(reset,e1)
		end
	end
	local res=c:IsSynchroSummonable(nil,mg) and c:IsSetCard(0x2)
	for _,te in ipairs(reset) do
		te:Reset()
	end
	return res
end
function s.rescon(set)
	return function(sg,e,tp,mg)
				return Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil,sg,e:GetHandler(),set)
			end
end
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg=c:GetLinkedGroup()
		return aux.SelectUnselectGroup(mg,e,tp,nil,nil,s.rescon(false),0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetLinkedGroup()
	local reset={}
	for tc in aux.Next(mg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e1)
		table.insert(reset,e1)
	end
	local tg=aux.SelectUnselectGroup(mg,e,tp,nil,nil,s.rescon(true),1,tp,HINTMSG_SMATERIAL,s.rescon(true))
	for _,te in ipairs(reset) do
		te:Reset()
	end
	local rreset={}
	for sc in aux.Next(tg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		sc:RegisterEffect(e1)
		table.insert(rreset,e1)
	end
	local syng=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_EXTRA,0,nil,tg,c,true)
	if #syng>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local syn=syng:Select(tp,1,1,nil):GetFirst()
		Duel.SynchroSummon(tp,syn,nil,tg)
	else
		for _,te in ipairs(rreset) do
			te:Reset()
		end
	end
end